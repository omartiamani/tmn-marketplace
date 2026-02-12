# Backend

**Technology Stack**:

- Azure Functions
- Bun
- TypeScript

**Testing Stack**:

- **Framework**: bun:test
- **HTTP Testing**: Supertest
- **Mocking**: bun:test mocks

**Best Practices**:

- Use in-memory database or test database for integration tests
- Test both success and error responses
- Validate HTTP status codes, headers, and response bodies
- Test authentication/authorization separately from business logic
- Mock external API calls

**Example API TDD**:

```javascript
// RED: Write failing test
describe("POST /api/users", () => {
  it("should create user and return 201 with user data", async () => {
    const newUser = {
      email: "newuser@example.com",
      password: "SecurePass123!",
      name: "New User",
    };

    const response = await request(app)
      .post("/api/users")
      .send(newUser)
      .expect(201);

    expect(response.body).toMatchObject({
      id: expect.any(Number),
      email: "newuser@example.com",
      name: "New User",
    });
    expect(response.body.password).toBeUndefined();
  });
});

// GREEN: Implement endpoint
// REFACTOR: Extract validation, move business logic to service layer
```
