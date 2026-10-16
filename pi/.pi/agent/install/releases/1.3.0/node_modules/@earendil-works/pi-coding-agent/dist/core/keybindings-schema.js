import { Type } from "typebox";
import { KeybindingValueSchema, keybindingValueSchema } from "./key-id-schema.js";
import { KEYBINDINGS } from "./keybindings.js";
export { KeybindingValueSchema } from "./key-id-schema.js";
const properties = {
    $schema: Type.Optional(Type.String()),
};
for (const [id, definition] of Object.entries(KEYBINDINGS)) {
    properties[id] = Type.Optional(keybindingValueSchema({
        description: definition.description,
    }));
}
export const KeybindingsSchema = Type.Object(properties, {
    additionalProperties: KeybindingValueSchema,
});
//# sourceMappingURL=keybindings-schema.js.map