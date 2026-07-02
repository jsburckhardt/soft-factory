# Soft Factory Skill Templates

These templates define the artifact contracts consumed by Soft Factory Skills. They are intentionally shared across Skills so path changes, ledger changes, and artifact shape changes can be made in one place.

## Templates

| Template | Purpose |
|----------|---------|
| `artifact-contract.md` | Canonical artifact paths and ledger locations for RPIV outputs and architecture records. |
| `research-brief.md` | Research stage output contract. |
| `action-plan.md` | Plan stage action plan contract. |
| `task-breakdown.md` | Plan stage task breakdown contract. |
| `test-plan.md` | Plan stage test plan contract. |
| `implementation-notes.md` | Implement stage implementation notes contract. |
| `verify-summary.md` | Verify stage persistent summary contract. |
| `decision-log.md` | Architecture decision ledger contract. |
| `adr.md` | ADR document contract. |
| `core-component.md` | Core-component document contract. |

## Usage

Skills SHOULD load `artifact-contract.md` before writing RPIV, ADR, core-component, or decision-ledger artifacts.

Skills SHOULD load the specific artifact template before generating that artifact.

If repository instructions move artifact locations or change ledger structure, update these templates first, then update Skill process constants only when the process needs a new lookup path.
