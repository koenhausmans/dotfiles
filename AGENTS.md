# Documentation

Keep READMEs short, compact, and focused on the reader's task.

| Location | Content |
| --- | --- |
| Root `README.md` | Quick install, brief component overview, shared local-config locations, and links to details. |
| `<component>/README.md` | Component setup, behavior, shortcuts, customization, and necessary caveats. For bat, use `bat/README.md`. |
| `bin/README.md` | Script catalog: invocation, important options, dependencies, and side effects. |
| `themes/<tool>/README.md` | Tool-specific theme setup and selection. |

When documenting a change, read the relevant README and update the owning
component's documentation alongside the code. Create a component README when
needed and link it from the root's **More** section. Move detailed root sections
to their component README, retaining a short link. Keep each explanation in one
place; use relative links for references. Before finishing, check that links
resolve and the root remains a quick-start page rather than a feature manual.

# Validation

Existing shell-syntax and installer smoke tests: `python3 -m unittest discover tests`.
Keep these tests; do not add test suites or CI automation.
