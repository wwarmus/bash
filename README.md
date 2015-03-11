Scripts
====

*Programming Convention*
 - functions are stored in lib/ directory and are declared in the following format: f_{v,n,s}_camelCaseName, where
   - f_ is for [f]unction
   - \_v\_ is for [v]oid
   - \_n\_ is for [n]umeric
   - \_s\_ is for [s]tring
 - library f_libLoad is used as a builtin source replacement, since otherwise sourcing fails when running executable from whatever other place than its location
