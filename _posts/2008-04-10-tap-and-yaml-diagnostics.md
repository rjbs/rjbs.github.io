---
layout: post
title : "tap and yaml diagnostics"
date  : "2008-04-10T03:48:57Z"
tags  : ["perl", "programming", "testing"]
---
For fun, I patched a copy of Test::Builder to do YAML diagnostics, which were
discussed quite a bit at the Oslo QA Hackathon.  It uses a mechanism that
Schwern said would be unsuitable for real use, presumably due to threading or
some other case that I don't care about.  (Or, at least, that I don't care
about for playing around with.)

Reading the diagnostic output is pretty easy, and it's exciting to see it in
action.  It also makes me grumpy about some of Perl's YAML support.  I started
out using YAML::XS, which kept printing `''` instead of `~` for an undef, even
though I couldn't produce the problem outside of my Test::Builder test.  I
switched to YAML::Syck, but that has other known problems.

Also, when humans don't manage the ordering of the YAML output, it can get a
bit ugly:

```yaml
file: foo.t
data:
  have: 1
  want: 2
line: 6
message: Failed test
```

Ugh.  Much nicer would be:

```yaml
message: Failed test
file: foo.t
line: 6
data:
  have: 1
  want: 2
```

I can't force that, though, without resorting to evil.  It could be easier with
a better YAML emitter, but I think this is somewhere that we'll just start to
need a better presentation layer to take care of the ugly for us.

I also realized that some things will just look better in diagnostic comments
than in YAML.  I don't think there's any really great way to redo this in
usefully structured YAML:

```
# got (hex)            got          expect (hex)         expect    
# 416c6c20435220616e64 All CR and = 416c6c20435220616e64 All CR and
# 206e6f204c46206d616b  no LF mak = 206e6f204c46206d616b  no LF mak
# 6573204d616320612064 es Mac a d = 6573204d616320612064 es Mac a d
# 756c6c20626f792e0d41 ull boy..A = 756c6c20626f792e0d41 ull boy..A
# 6c6c20435220616e6420 ll CR and  = 6c6c20435220616e6420 ll CR and 
# 6e6f204c46206d616b65 no LF make = 6e6f204c46206d616b65 no LF make
# 73204d61632061206475 s Mac a du = 73204d61632061206475 s Mac a du
# 6c6c20626f792e0d416c ll boy..Al ! 6c6c20626f792e0a416c ll boy..Al
# 6c20435220616e64206e l CR and n = 6c20435220616e64206e l CR and n
# 6f204c46206d616b6573 o LF makes = 6f204c46206d616b6573 o LF makes
# 204d616320612064756c  Mac a dul = 204d616320612064756c  Mac a dul
# 6c20626f792e0d416c6c l boy..All ! 6c20626f792e0a416c6c l boy..All
# 20435220616e64206e6f  CR and no = 20435220616e64206e6f  CR and no
# ...
```

...but maybe I'm wrong.  That could be a sequence of comparisons, each one made
up of a five element flow-formatted sequence... but I think it would suck.  The
quoting would get in the way.

That's fine.  It's nice to be able to pick what kind of output to provide.
Heck, that could be provided in the YAML stream as a here-doc.

Here's my patch, as it stands now:

```diff
--- /usr/local/lib/perl5/5.10.0/Test/Builder.pm	2007-11-29 18:41:31.000000000 -0500
+++ lib/Test/Builder.pm	2008-04-09 23:35:21.000000000 -0400
@@ -381,6 +381,23 @@
 
 =cut
 
+use YAML::Syck qw(Dump);
+sub __end_previous {
+  my ($self) = @_;
+  
+  my ($data) = delete $self->{__yaml};
+  return unless $data;
+  my $yaml = Dump($data) if $data;
+  $yaml =~ s/^/  /gm;
+
+  print "$yaml  ...\n";
+}
+
+sub add_diagnostics {
+  my ($self, %data) = @_;
+  ($self->{__yaml} ||= {})->{$_} = $data{$_} for keys %data;
+}
+
 sub ok {
     my($self, $test, $name) = @_;
 
@@ -390,6 +407,7 @@
 
     $self->_plan_check;
 
+    $self->__end_previous;
     lock $self->{Curr_Test};
     $self->{Curr_Test}++;
 
@@ -449,11 +467,18 @@
         $self->_print_diag("\n") if $ENV{HARNESS_ACTIVE};
 
  if( defined $name ) {
-	    $self->diag(qq[  $msg test '$name'\n]);
-	    $self->diag(qq[  at $file line $line.\n]);
+	    $self->add_diagnostics(
+        message => qq[$msg test '$name'],
+        file    => $file,
+        line    => $line,
+      );
  }
  else {
-	    $self->diag(qq[  $msg test at $file line $line.\n]);
+	    $self->add_diagnostics(
+        message => qq[$msg test],
+        file    => $file,
+        line    => $line,
+      );
  }
     } 
 
@@ -572,7 +597,7 @@
         if( defined $$val ) {
             if( $type eq 'eq' ) {
                 # quote and force string context
-                $$val = "'$$val'"
+                $$val = "$$val"
             }
             else {
                 # force numeric context
@@ -580,15 +605,16 @@
             }
         }
         else {
-            $$val = 'undef';
+            $$val = undef;
         }
     }
 
-    return $self->diag(sprintf <<DIAGNOSTIC, $got, $expect);
-         got: %s
-    expected: %s
-DIAGNOSTIC
+    $self->add_diagnostics(data => {
+      have => $got,
+      want => $expect,
+    });
 
+    return;
 }    
 
 =item B<isnt_eq>
@@ -1686,6 +1712,7 @@
 sub _ending {
     my $self = shift;
 
+    $self->__end_previous;
     $self->_sanity_check();
 
     # Don't bother with an ending if this is a forked copy.  Only the parent
```

