---
layout: post
title : "toward email::simple 2.0"
date  : "2007-05-30T13:25:21Z"
tags  : ["email", "perl", "programming"]
---
First:                                                                          
                                                                                  
    In case you're subscribed, note that the pep-checkins is currently busted.  I
    haven't even looked into it, yet.  We moved PEP svn from a standalone machine
    to a Solaris zone recently, and I probably broke something stupid.            
                                                                                  
I bring this up because I know that it means none of you have probably seen the 
Email::Simple checkins I made yesterday.  I'm trying to get ready to release    
Email::Simple 2.000.  It's going to be a great release, I think.  I'm not       
trying to do the crazy "not-backwards-compatible changes at major version       
number!" thing.  Instead, I'm trying to document and standardize more of the    
interface.  My mantra for the 2.x series of Email::Simple is "better interface  
standardization."  I want it to do roughly the same amount of stuff, with       
roughly the same performance.  I just want it to be clearer how one can         
subclass Email::Simple, and I want to refactor, document, and improve the       
usability of the core features of Email::Simple.  (This will probably include a 
rewrite of the Email::Simple<->Data::Message relationship.)                     
                                                                                  
Here's a summary of things I checked in last night:                             
                                                                                  
    * better documentation for the Email::Simple::Header object                   
    * provide a means to request a different header class                         
    * public interface for header folding                                         
    * documented how options are passed to Email::Simple constructor              
    * add options to as_string, namely options to alter header folding            
    * add methods that return default values of various options                   
    * some performance improvements                                               
                                                                                  
These changes are mostly here to make it easier to subclass Email::Simple's     
behavior.  In almost every case, I want the answer to "how do I change          
Email::Simple's" behavior to be "subclass" or (later) "use a plugin."  Since    
some features are really very fundamental core features, though, they seemed    
like a good place to demonstrate my intentions.                                 
                                                                                  
I'm going to release this as a _x release, soon.  Please let me know, now or    
then, if you have any thoughts.                                                 


