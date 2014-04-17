# cs252-instacat-server

Instacat server for CS252

# Dev setup

```
npm install
npm run-script dev
npm start
npm stop
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

All these routes return JSON (except for .jpg obviously) and require basic auth (except for user creation). For security we can implement SSL if we choose.

### `POST /api/users/new`

* `handle` the handle
* `name` the full name
* `password` the password

### `POST /api/images/new`

* `image` the uploaded file

### `GET /api/images/`

### `GET /api/images/:image_uuid`

### `POST /api/images/:image_uuid/like`

### `POST /api/images/:image_uuid/comment`

* `comment` the textcomment

### `GET /api/images/:image_uuid.jpg`

### `GET /api/users/:handle`
