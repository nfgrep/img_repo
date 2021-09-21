# img_repo

Upload, view, search, delete and resize your images!  
This project is a submission to the 2021 Winter internship application at Shopify.

## Features

- Add an image
- Delete an image
- Get an image
- Search images by title
- Get a resized image

## Setup

1. Download a copy of this repository, either via the [.zip download](https://github.com/nfgrep/img_repo/archive/refs/heads/main.zip) or `git clone`

   ```
   git clone https://github.com/nfgrep/img_repo
   ```

2. Open a terminal and navigate to the root of the project

   ```
   cd img_repo
   ```

3. Build the docker image

   ```
   docker build . -t img_repo
   ```

4. Run the docker image with port 3000 exposed

   ```
   docker run -p 3000:3000 img_repo
   ```

5. Done! The server should now be available at localhost:3000

   ![](demo-img/first-test.png)

## Usage

### Upload an image

Send a `POST` to `/images/` with formdata containing a `file:file` and a `title:string` parameter:

![](demo-img/upload.png)

### See what images exist

Send a `GET` to `/images/`:

![](demo-img/view-all.png)

### Get an image

Send a `GET` to `/images/:id` where `:id` is the id of your desired image:

![](demo-img/view.png)

### Search an image

Send a `GET` to `/images/search/:query` where `:query` is your search string:

![](demo-img/search.png)

### Get a resized image

Send a `GET` to `/images/:id/:size` where `:id` is the id of your desired image, and `:size` is the size:

![](demo-img/resize.png)

### Delete an image

Send a `DELETE` to `/images/:id` where `:id` is the id of the image you'd like to delete:

![](demo-img/delete.png)
