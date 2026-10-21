# Notes Taking App

A basic React app for writing and managing notes, built with Vite. Notes persist in `localStorage`.

## Stack

- React 18
- Vite 5
- Plain CSS

## Run

```
npm install
npm run dev
```

## Features

- Create, edit, and delete notes
- Auto-save to localStorage
- Sidebar list with live previews
- Last-updated timestamp per note

## Sibling apps

`clone-supporting-apps.sh` clones the three sibling React apps (Hungama, E-Commerce, Appointment-Booking) into a local `supporting-apps/` directory for side-by-side development.

```
./clone-supporting-apps.sh
```

Optional arguments: target directory and branch (defaults to `supporting-apps` and `bc/217fd4e8-create-basic-level`, which is the branch that contains the React app code). The script is idempotent — already-cloned repos are skipped.
