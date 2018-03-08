# electron-spotlight
Index or remove items in macOS Spotlight, using a native Node module.

## Quick-start

```
npm i electron-spotlight
```

``` js
import { addItems } from 'electron-spotlight';

addItems([{
  id: 'your-unique-identifier',
  title: 'Title In Spotlight',
  icon: 'https://pbs.twimg.com/media/CdlFCYmXIAAGkiH.jpg'
}])
```

## API

### `addItems(items: Array<SearchItem>)`
Index items within Spotlight. Maps to [`indexSearchableItems`](https://developer.apple.com/documentation/corespotlight/cssearchableindex/1620333-indexsearchableitems?language=objc).

```
export interface SearchItem {
  id: string;
  title: string;
  icon?: string;
}
```

Note that you must be on a _signed build_ to communicate with `corespotlightd`. Otherwise you'll see `Unable to communicate with helper app`.

### `removeItems(ids: Array<string>)`
Removes items from Spotlight according to their unique identifier. Maps to [`deleteSearchableItemsWithIdentifiers`](https://developer.apple.com/documentation/corespotlight/cssearchableindex/1620337-deletesearchableitemswithidentif?language=objc).

### `removeAllItems()`
Removes all items from Spotlight indexing. Maps to [`deleteAllSearchableItemsWithCompletionHandler`](https://developer.apple.com/documentation/corespotlight/cssearchableindex/1620342-deleteallsearchableitemswithcomp?language=objc).
