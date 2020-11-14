BRADY_SQL

Goals:
   
Step 1: Use Bison and Flex to scan strings to verify it's correct SQL format
and construct the statement objects to be used

Step 2: Storage, Buffer Pool Manager and other classes need to be written
to allow pages to be swapped in and out of memory to on disk

Step 3: Support more types, currently only INT and VARCHAR are supported

Step 4: Support for more complex queries
- Complex where conditions
- Complex select statements

Step 5: Design Query Optimizer: Need to boilerplate classes and data to
be in place before this is possible

Step 6: Allow concurrent requests through TCP socket with TLS 
encryption
- Most of the work is to design a client to make requests and display
results in user friendly way.

Step 7: Foreign key support
- If I am ambitious enough to implement this and other algorithms
associated with the workload this would take


