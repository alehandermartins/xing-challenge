# PlayList app

## For Importing data
### Importing
Put file inside csv directory and then pass file name

```
rake import_data:user file: file_name
```

# Modifications

- Importing data on bulks
- Refactorization and specs for tasks
- Added Devise with jwt for api authentication
- Changed infrastructure for api isolation
- Rewoked user endpoints and specs taking into account authentication
- Added playlist endpoints
- Adding and removing mp3 to playlists
- Added view for users and their playlists
- Reworked multiple specs
- Removed unnecessary code


## API Endpoints

App API will expose the following RESTful endpoints.

| Endpoint | Functionality |
| --- | --- |
| GET /users | List all users |
| POST /api/login | login with email and password. Returns jwt token for further api calls|
| POST /api/users | Create a new user |
| PUT /api/users/:id | Update current user (password must be provided) |
| GET /api/users/:id | Show current user details |
| DELETE /api/users/:id | Deletes current user |
| GET /api/play_lists | Show all playlist of current user|
| POST /api/play_lists | Create a new play_list for current user |
| PUT /api/play_lists/:id | Updates current user playlist |
| GET /api/play_lists/:id | Show details of playlist with provided id for the current user|
| DELETE /api/play_lists/:id | Deletes playlist |
| POST /api/play_lists/:id/add_mp3 | Adds mp3 to playlist |
| POST /api/play_lists/:id/remove_mp3 | Removes mp3 from playlist |
