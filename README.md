# edi-schemas
Schemas for X12 and EDIFACT as JSON.

These were converted using a [script](./generate-schemas.sh) from the [BOTS EDI translator grammars](https://github.com/bots-edi/bots-grammars).
Using this, an EDI generator or parser can be written in any programming language.

## Structure
Under each folder, there will be a JSON file prefixed with `records` which contains the segment definitions. The other files
contain the definitions for the actual message types.
