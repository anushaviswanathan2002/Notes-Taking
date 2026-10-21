# Character Casing Support for SfTextBoxExt

## Module Information

| Item | Value |
|--------|--------|
| Feature | Character Casing |
| Control | SfTextBoxExt |
| Platform | WPF |
| Feature Type | Text Input Processing |
| Impact | User Input Only |
| Existing Text Modification | No |

---

## 1. Objective

Implement CharacterCasing support for the WPF SfTextBoxExt control.

The feature must:

- Support Normal casing.
- Support Upper casing.
- Support Lower casing.
- Apply conversion only to newly entered text.
- Preserve existing text values.
- Preserve caret position.
- Support keyboard input.
- Support IME input.
- Support paste operations.
- Be implemented only for WPF builds.

---

## 2. Public APIs

### CharacterCasing Property

```csharp
public CharacterCasing CharacterCasing
{
    get;
    set;
}
```

### Supported Values

- Normal: No conversion
- Upper: Converts newly entered text to uppercase
- Lower: Converts newly entered text to lowercase

---

## 3. Dependency Property Registration

```csharp
public static readonly DependencyProperty CharacterCasingProperty =
    DependencyProperty.Register(
        nameof(CharacterCasing),
        typeof(CharacterCasing),
        typeof(TextBoxExt),
        new PropertyMetadata(
            CharacterCasing.Normal,
            OnCharacterCasingChanged));
```

---

## 4. Property Changed Callback

```csharp
private static void OnCharacterCasingChanged(
    DependencyObject d,
    DependencyPropertyChangedEventArgs e)
{
    var textBox = (TextBoxExt)d;

    textBox.OnCharacterCasingChanged(
        (CharacterCasing)e.OldValue,
        (CharacterCasing)e.NewValue);
}
```

---

## 5. Runtime Behavior Rules

1. Changing CharacterCasing must not modify existing text.
2. Only newly entered text shall be transformed.
3. Programmatic Text assignments shall not be modified.

---

## 6. Character Conversion Logic

```csharp
private string ApplyCharacterCasing(string text)
{
    switch (this.CharacterCasing)
    {
        case CharacterCasing.Upper:
            return text.ToUpper();

        case CharacterCasing.Lower:
            return text.ToLower();

        default:
            return text;
    }
}
```

---

## 7. Input Processing

### Keyboard Input
Apply conversion for typed characters.

### IME Input
Apply conversion after IME commit.

### Paste Operations
Apply conversion to pasted content.

---

## 8. Caret Preservation

Preserve:

- CaretIndex
- SelectionStart
- SelectionLength

---

## 9. Input Event Integration

Recommended integration points:

- PreviewTextInput
- IME Commit Handling
- Paste Command Handling

---

## 10. Refresh Triggers

Execute conversion when:

- Keyboard Input
- IME Input
- Paste Operations

Do not execute conversion for:

- Existing Text
- Runtime Property Changes
- Programmatic Text Assignments

---

## 11. Platform Restriction

Supported Platform:

```text
WPF
```

---

## 12. Acceptance Criteria

- Normal mode preserves input.
- Upper mode converts newly entered text to uppercase.
- Lower mode converts newly entered text to lowercase.
- Existing text remains unchanged.
- Paste operations respect CharacterCasing.
- Programmatic text assignments remain unchanged.

---

## 13. AI Agent Implementation Checklist

- Add CharacterCasing dependency property.
- Implement ApplyCharacterCasing().
- Handle Keyboard Input.
- Handle IME Input.
- Handle Paste Operations.
- Preserve Caret and Selection State.
- Restrict implementation to WPF.

---

## Final Design Rule

1. Normal → No conversion.
2. Upper → Convert newly entered text to uppercase.
3. Lower → Convert newly entered text to lowercase.
4. Do not modify existing text when property changes.
5. Do not modify programmatically assigned text.
6. Preserve caret and selection.
7. Apply conversion for keyboard, IME, and paste input.
8. WPF only.
