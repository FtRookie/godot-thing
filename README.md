# godot-thing

A Godot 4 project written in C#. Right now it is a single 2D scene: the Godot icon, moved with the arrow keys.

## Requirements

- **Godot 4.7.2, .NET edition.** The standard download has no C# support; get the build labelled ".NET" from
  [godotengine.org/download](https://godotengine.org/download).
- **.NET SDK 8.0 or newer.** The project targets `net8.0`; newer SDKs build it fine. Check with `dotnet --list-sdks`.

## Getting started

1. Clone the repository.
2. Open Godot, choose **Import**, and select `project.godot` in the cloned folder.
3. Press **F5**. The first run builds the C# assembly, then opens the main scene.
4. Move the icon with the arrow keys.

The editor imports the project when it opens it. If you run the project from the command line instead, import it
first — the main scene is referenced by UID, and UIDs only resolve once the `.godot/` cache exists:

```bash
godot --headless --path . --import
godot --path .
```

`.godot/` is generated and gitignored. Deleting it is always safe; the next import rebuilds it.

## Editing in VS Code

Opening the folder prompts you to install the recommended extensions from `.vscode/extensions.json`:

- **C#** (`ms-dotnettools.csharp`) — language server, formatting, analyzers
- **godot-csharp-vscode** (`neikeq.godot-csharp-vscode`) — Godot integration for C#
- **EditorConfig** (`editorconfig.editorconfig`) — applies `.editorconfig` to non-C# files

The workspace settings format and organize usings on save, and report analyzer warnings for the whole project in
the Problems panel rather than only for open files.

## Checking your changes

```bash
dotnet build
dotnet format godot-thing.sln --verify-no-changes
```

The build treats nullable reference types and the recommended .NET analyzers as warnings; a clean change produces
none. `dotnet format` needs the solution named explicitly, because both a `.sln` and a `.csproj` sit in the root.
Run `dotnet format godot-thing.sln` without `--verify-no-changes` to apply fixes.

## Code style

Style lives in `.editorconfig`: tabs, 120-column lines, LF endings, file-scoped namespaces, explicit access
modifiers. A few Godot-specific points:

- Scripts are `partial` classes, and the file name must match the class name exactly — Godot finds the script's
  class by that name.
- Fields assigned in `_Ready` rather than a constructor are declared `= null!`, since the engine, not the
  constructor, initializes them.
- Inspector-editable values use `[Export]` on a public property.
- Scene files (`*.tscn`) are edited in the Godot editor, not by hand.
