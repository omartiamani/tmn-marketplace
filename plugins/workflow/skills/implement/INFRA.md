# Infrastructure tasks

Infrastructure as code does not lend itself to the red-green cycle: there is no unit test to make fail before declaring a resource. The verification loop is different, but it is just as demanding.

1. **Write the declaration**, then run the validation and the **plan**. Read it in full: what is created, modified, and above all **destroyed**. A plan that contains a destruction not provided for in the ticket stops there and is reported.
2. **Have the plan approved** before any deployment. An infrastructure deployment is not an operation you can reverse with a simple undo.
3. **Deploy to the development environment only**, unless explicitly instructed about another environment. Check which subscription and which environment you are pointing at before applying.
4. **After deployment, verify that the resource actually exists** and that it is configured as expected — query the provider, not the state file: the real world is authoritative, not the declaration.
5. **Verify what consumes the resource** when there is something: an established connection, a readable secret, an effective permission.

Report the plan applied and what the verification found, resource by resource.
