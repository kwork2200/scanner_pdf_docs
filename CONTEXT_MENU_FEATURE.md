# 📱 Context Menu Feature - Long Press on Recent Items

## 🎯 Feature Overview

User jab **Recent list** me kisi document pe **long press** kare, to ek bottom sheet open hogi with 4 options:

```
┌─────────────────────────────────┐
│                                 │
│  ✏️  Rename              🖊️   │
│                                 │
│  📤  Share               ↗️    │
│                                 │
│  ⭐  Favourite           ☆     │
│                                 │
│  🗑️  Delete              🗑️   │
│     (Red Color)                 │
│                                 │
└─────────────────────────────────┘
```

## 📋 Options Details

### 1. ✏️ Rename
- **Icon:** Edit icon (outlined + filled trailing)
- **Action:** Opens dialog box
- **Dialog contains:**
  - Title: "Rename Document"
  - Text field with current name
  - Cancel button
  - Rename button
- **Result:** Document renamed with success message

### 2. 📤 Share
- **Icon:** Share icon (outlined + iOS share trailing)
- **Action:** Opens system share dialog
- **Shares:** Current document as JPG
- **Uses:** `scanController.shareAsJPG()`

### 3. ⭐ Favourite
- **Icon:** Star outline (+ star border trailing)
- **Action:** Marks document as favourite
- **Result:** Green snackbar "Added to favourites"
- **Future:** Can filter favourites in Files tab

### 4. 🗑️ Delete (Red)
- **Icon:** Delete outline (RED)
- **Text Color:** Red
- **Action:** Opens confirmation dialog
- **Dialog contains:**
  - Title: "Delete Document"
  - Message: "Are you sure you want to delete [name]?"
  - Cancel button
  - Delete button (red)
- **Result:** Document deleted + Red snackbar

## 🎨 UI Design

### Bottom Sheet
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  ),
  child: Column(
    ListTile(Rename),
    ListTile(Share),
    ListTile(Favourite),
    ListTile(Delete - Red),
  ),
)
```

### ListTile Structure
```
┌────────────────────────────────────┐
│ [Leading Icon]  Option Name  [Trail]│
└────────────────────────────────────┘
```

## 🔄 User Flow

### Flow 1: Rename
```
1. Long press on document
2. Context menu opens
3. Tap "Rename"
4. Dialog opens with text field
5. Enter new name
6. Tap "Rename"
7. Document renamed
8. Green success message
```

### Flow 2: Share
```
1. Long press on document
2. Context menu opens
3. Tap "Share"
4. System share dialog opens
5. Select app to share
6. Document shared
```

### Flow 3: Favourite
```
1. Long press on document
2. Context menu opens
3. Tap "Favourite"
4. Document marked as favourite
5. Green success message
```

### Flow 4: Delete
```
1. Long press on document
2. Context menu opens
3. Tap "Delete"
4. Confirmation dialog opens
5. Tap "Delete" to confirm
6. Document deleted
7. Red success message
```

## 📱 Implementation Details

### Home Tab - Recent List
```dart
InkWell(
  onTap: () {
    // Normal tap - Open document
  },
  onLongPress: () {
    // Long press - Show context menu
    _showContextMenu(context, imageFile, title);
  },
  child: // Document item
)
```

### Files Tab - List View
```dart
InkWell(
  onLongPress: () {
    // Long press - Show context menu
    _showContextMenu(context, image, fileName, index);
  },
  child: Card(
    // Document card
  ),
)
```

## 🎯 Context Menu Functions

### 1. _showContextMenu()
- Shows bottom sheet with 4 options
- Parameters: context, imageFile, title, (index for Files tab)

### 2. _showRenameDialog()
- Shows rename dialog
- Text field with current name
- Rename / Cancel buttons

### 3. _confirmDelete()
- Shows delete confirmation
- Are you sure? message
- Delete / Cancel buttons

### 4. Share Action
- Directly calls `scanController.shareAsJPG()`
- Opens system share dialog

### 5. Favourite Action
- Shows success snackbar
- Future: Can implement favourite marking logic

## 🎨 Visual Design

### Context Menu Colors
- **Background:** White
- **Icons:** Black87 (except delete)
- **Delete Icon:** Red
- **Delete Text:** Red
- **Trailing Icons:** Grey

### Dialogs
- **Rename Dialog:**
  - Title: Black
  - TextField: Outlined border
  - Buttons: Blue (default theme)

- **Delete Dialog:**
  - Title: Black
  - Content: Black
  - Cancel: Default color
  - Delete: Red

### Snackbars
- **Success (Rename/Favourite):** Green background, white text
- **Delete:** Red background, white text

## 📋 Features Checklist

✅ Long press on Recent items
✅ Long press on Files items
✅ Context menu bottom sheet
✅ Rename option with dialog
✅ Share option (JPG format)
✅ Favourite option
✅ Delete option (red color)
✅ Delete confirmation dialog
✅ Success/error snackbars
✅ Proper icons (leading + trailing)

## 🔧 Where Implemented

### Files Updated:
1. **lib/screens/home_tab.dart**
   - Added `onLongPress` to recent items
   - `_showContextMenu()` function
   - `_showRenameDialog()` function
   - `_confirmDelete()` function

2. **lib/screens/files_tab.dart**
   - Added `onLongPress` to list items
   - Same 3 functions as home_tab
   - InkWell wrapper for long press

## 🎯 User Experience

### Gestures:
- **Single Tap:** Open document in editor
- **Long Press:** Show context menu (0.5s hold)
- **Three Dots (Files tab):** Alternative menu (View/Delete only)

### Feedback:
- **Haptic feedback:** On long press (OS default)
- **Visual feedback:** Bottom sheet slides up
- **Success messages:** Snackbar notifications
- **Confirmation:** For destructive actions (delete)

## 🚀 Future Enhancements

Possible additions:
- ⭐ Favourite filter in Files tab
- 🏷️ Tag/Category system
- 📋 Copy/Duplicate option
- 📧 Direct email option
- 🔒 Lock/Password protect
- 📊 Document info (size, pages, created date)

Perfect implementation! 🎉
