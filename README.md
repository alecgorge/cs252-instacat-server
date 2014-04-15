# cs252-instacat-server

Instacat server for CS252

# Dev setup

```
npm install
```

# Spec

No following or anything like that initially. Just a global stream of cat pictures you can like and comment on.

* Users
  * Name (up to 50 chars)
  * Handle (up to 16 chars)
  * Password [stored securely as a bcrypt hash](http://codahale.com/how-to-safely-store-a-password/)
* Images
  * [UUID unique key](https://github.com/broofa/node-uuid)
  * All inputs should be JPG. Client will convert and downsize to JPG square.
  * Comments
  * Likes

To implement comments and likes, we will need 2 extra tables that map between user ids and image ids

## Routes

All these routes return JSON (except for .jpg obviously) and require basic auth. For security we can implement SSL if we choose.

### `POST /api/image`

### `GET /api/images/`

### `GET /api/images/:image_uuid`

### `GET /api/images/:image_uuid.jpg`

### `GET /api/users/:handle`
