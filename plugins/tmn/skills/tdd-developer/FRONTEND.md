# Frontend

**Design-to-Code Workflow**:

When implementing screens or components from Figma designs, **always use Figma MCP tools** to extract design context:

1. **`mcp__figma-desktop__get_design_context`** - Primary tool for generating UI code from a Figma node. Use this to get structured design information including layout, styles, and component hierarchy.

2. **`mcp__figma-desktop__get_screenshot`** - Get a visual screenshot of the design for reference.

3. **`mcp__figma-desktop__get_variable_defs`** - Extract design tokens (colors, spacing, typography) used in the design.

4. **`mcp__figma-desktop__get_metadata`** - Get an overview of the design structure when you need to understand the node hierarchy.

**Usage**: When the user provides a Figma URL or mentions a specific screen/component to implement:
- Extract the `nodeId` from the URL (format: `node-id=1-2` → `1:2`)
- Call `get_design_context` first to understand the design structure
- Use the extracted styles, spacing, and layout to inform your implementation
- Reference `get_variable_defs` to use consistent design tokens

**Technology Stack**:

- React Native
- Expo
- TypeScript
- Bun

**Testing Stack**:

- **Framework**: bun:test
- **React Testing**: React Native Testing Library (@testing-library/react-native)

**Best Practices**:

- Test behavior, not implementation details
- Query by accessible labels, roles, text (not by CSS classes or test IDs unless necessary)
- Use `userEvent` over `fireEvent` for realistic interactions
- Test accessibility (ARIA roles, keyboard navigation)
- Mock API calls at the network level (MSW - Mock Service Worker)
- **Do NOT write unit tests for RTK Query API calls** - only test features/screens that use them
- **Skip unit tests for simple presentational components** - components that only display data with no complex logic (e.g., cards, list items, badges). Test them through integration tests at the screen level instead.
- **DRY test setup**: When multiple tests render the same component with the same inputs, render once and reuse:
  - Use `beforeAll` when tests only read/assert displayed content without mutating state
  - Use `beforeEach` only when tests perform interactions that mutate state and would affect subsequent tests
  - For interaction tests that mutate state, consider grouping them in a separate `describe` block with their own setup
- **Minimize mocking**: Only mock what's strictly necessary (external API calls, native modules, timers). Avoid mocking internal modules, Redux stores, or React hooks unless absolutely required. Use the real implementations when possible - they catch more bugs and make tests more reliable.

**Testing Anti-Patterns to Avoid**:

1. **Consolidate display assertions**: When testing that a component displays multiple pieces of data correctly, write ONE test case that asserts all display elements together. Do NOT create separate test cases for each displayed value.
   ```javascript
   // WRONG - Multiple renders
   it("should display exercise name", () => {
     render(<ExerciseCard exercise={mockExercise} />);
     expect(screen.getByText("Bench Press")).toBeInTheDocument();
   });
   it("should display muscle group", () => {
     render(<ExerciseCard exercise={mockExercise} />);
     expect(screen.getByText("Chest")).toBeInTheDocument();
   });

   // CORRECT - Single render
   it("should display exercise information correctly", () => {
     render(<ExerciseCard exercise={mockExercise} />);
     expect(screen.getByText("Bench Press")).toBeInTheDocument();
     expect(screen.getByText("Chest")).toBeInTheDocument();
     expect(screen.getByText("Primary")).toBeInTheDocument();
   });
   ```

2. **Do NOT test button existence separately**: The existence of a button is implicitly verified when testing its action. Only test the button's behavior.
   ```javascript
   // WRONG - Redundant existence check
   it("should render add set button", () => {
     render(<ExerciseCard exercise={mockExercise} />);
     expect(screen.getByRole("button", { name: /add set/i })).toBeInTheDocument();
   });

   // CORRECT - Test the action, existence is implicit
   it("should add a new set when add button is pressed", () => {
     render(<ExerciseCard exercise={mockExercise} />);
     fireEvent.press(screen.getByRole("button", { name: /add set/i }));
     // Assert the expected behavior (state change, UI update)
   });
   ```

3. **Test Redux integration properly**: When testing components connected to Redux, verify that actions update state and UI reflects the change. Do NOT manually update mock data and re-render.
   ```javascript
   // WRONG - Manually simulating state change
   it("should display new set after adding", () => {
     const { rerender } = render(<ExerciseCard exercise={mockExercise} />);
     fireEvent.press(screen.getByText("Add Set"));

     // DON'T manually update mock and rerender
     mockExercise.sets.push({ reps: 0, weight: 0 });
     rerender(<ExerciseCard exercise={mockExercise} />);
   });

   // CORRECT - Let Redux update the state, verify UI change
   it("should display new set after adding", () => {
     render(<ExerciseCard exercise={mockExercise} />);
     expect(screen.getByText("No sets added yet")).toBeTruthy();

     fireEvent.press(screen.getByText("Add Set"));

     // Verify UI reflects the real state update
     expect(screen.queryByText("No sets added yet")).toBeNull();
     expect(screen.getByText("1")).toBeTruthy(); // Set row appears
   });
   ```

**Example Component TDD**:

```javascript
// RED: Write failing test
it("should submit form when all fields are valid", async () => {
  const onSubmit = vi.fn();
  render(<RegistrationForm onSubmit={onSubmit} />);

  await userEvent.type(screen.getByLabelText(/email/i), "test@example.com");
  await userEvent.type(screen.getByLabelText(/password/i), "SecurePass123!");
  await userEvent.click(screen.getByRole("button", { name: /register/i }));

  expect(onSubmit).toHaveBeenCalledWith({
    email: "test@example.com",
    password: "SecurePass123!",
  });
});

// GREEN: Implement minimal form
// REFACTOR: Extract validation logic, improve error handling
```
