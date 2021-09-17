## Sept 11

Installed ruby -v 3.0.2 the other day. Just tried to reinstall rails for this version. After running `gem install rails` I tried to run `rails` and got the following:

```
rbenv: rails: command not found

The `rails' command exists in these Ruby versions:
  2.6.5
  2.7.1
```

I tried removing the older versions of rails:

```
nfg@rep bin % gem uninstall rails
nfg@rep bin % rails
Traceback (most recent call last):
	8: from /Users/nfg/.rbenv/versions/2.6.5/bin/rails:23:in `<main>'
	7: from /Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems.rb:303:in `activate_bin_path'
	6: from /Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems.rb:303:in `synchronize'
	5: from /Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems.rb:304:in `block in activate_bin_path'
	4: from /Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:1420:in `activate'
	3: from /Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:1438:in `activate_dependencies'
	2: from /Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:1438:in `each'
	1: from /Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/specification.rb:1449:in `block in activate_dependencies'
/Users/nfg/.rbenv/versions/2.6.5/lib/ruby/2.6.0/rubygems/dependency.rb:313:in `to_specs': Could not find 'activesupport' (= 6.1.4.1) - did find: [activesupport-6.0.3.6,activesupport-6.0.3.4,activesupport-6.0.3.3,activesupport-6.0.2.1,activesupport-4.2.11.3] (Gem::MissingSpecVersionError)
Checked in 'GEM_PATH=/Users/nfg/.gem/ruby/2.6.0:/Users/nfg/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0:/Users/nfg/.gem', execute `gem env` for more information
```

`gem unisntall` seems to have forgot to remove `Users/nfg/.rbenv/versions/2.6.5/bin/rails`.  
After manual removal things work:

```
nfg@rep bin % gem install rails
Fetching rails-6.1.4.1.gem
Successfully installed rails-6.1.4.1
Parsing documentation for rails-6.1.4.1
Installing ri documentation for rails-6.1.4.1
Done installing documentation for rails after 0 seconds
1 gem installed
nfg@rep bin % rails
rbenv: rails: command not found
nfg@rep bin % rbenv rehash
nfg@rep bin % rails
Usage:
  rails new APP_PATH [options]
...
```

As you can see I needed to do a manual rehash, which is strange.  
I was expecting to see a new shell script in `Users/nfg/.rbenv/versions/3.0.2/bin`, but:

```
nfg@rep bin % which rails
/Users/nfg/.gem/bin/rails
```

Maybe all of this is a result of an error in my `.zshrc`, or perhaps an update to rbenv or gem.

Things to look at tomorrow:

- resource routes
- controller function name conventions

## Sept 15

I have been going through the rails [getting started](https://guides.rubyonrails.org/getting_started.html) guide to refresh my memory. I've been learning some things so I'll dump them here.

---

The `.build` method of nested RA objects is just an [alias for `.new`](https://github.com/rails/rails/blob/959fb8ea651fa6638aaa7caced20d921ca2ea5c1/activerecord/lib/active_record/relation.rb#L84).  
When used as the `model:` in `form_with` helper, .build spits out an actual object into the params.

For example,

```
<%= form_with model: [ @article, @article.comments.build ] do |form| %>
```

results in:

```
{"authenticity_token"=>"[FILTERED]", "comment"=>{"commenter"=>"ff", "body"=>"asdf"}, "commit"=>"Create Comment", "article_id"=>"3"}
```

While the article is represented as its ID, the comment is just a dictionary representing the object built from form data.

---

`redirect_to article_path(@article)` and `redirect_to @article` seem to do the same thing. Maybe `article_path` is just meant as syntactic sugar, or is a relic of the past.

---

Instead of referencing the specific views of a given model to render them, you can just reference the models:

```
render @article.comments
```

I imagine that `render` looks for the appropriate views to render, though in this case the appropriate views are a list of partials.

`render` can also just take a path to the view, like: `render "comment/form"`

---

Unsure what the `included` method of a concern does.  
From [api.rubyonrails.org](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html#method-i-included):

> Evaluate given block in context of base class, so that you can write class macros here. When you define more than one included block, it raises an exception.

Makes sense, this way we have context of the included class, neat!

---

`where` is an AR method that builds a query. It looks like its context-aware, so that you can just call it from within whatever model class you want to build a query for.

---

The `rails generate migration` command seems smart enough to notice the name of the migration and make changes to the correct table.  
For example, `rails generate migration AddStatusToArticles status:string` generates a migration adding a column to `articles`.

---

`<%= link_to 'Destroy Comment', [comment.article, comment] %>` yeilds parameters that include the id of the article as `article_id` and the comment id as `id`

---

## Onto the image repo

Ok, lets get some ideas going.

**Core Features**

- Basic CRUD, but no U. (CRD?)
- Single page that lists all images
- Add/upload and delete

**Extra Stuff**

- API stuff
- Hook things up to S3 or GCP storage ([how to do that](https://hixonrails.com/ruby-on-rails-tutorials/ruby-on-rails-active-storage-aws-s3-google-cloud-platform-microsoft-azure/))
- Host the app somewhere
- User-accounts/validation

---

First things first, gotta setup Active-Storage.  
With that done I can add a new model to store our image.

Looking through this guide on [using active storage with image data](https://pragmaticstudio.com/tutorials/using-active-storage-in-rails).  
The `has_one_attached` method seems to be what actually associates the model with active record.

Dude... theres a built-in field for uploading files in form data: `file_field` . So sick.

I'd like to add tags to my images, just so I'm storing something more than just the image data (and some simple searches/filters can be done).  
I want an image to have many tags, and a tag to have many images. This will almost certainly require a join table. I'll leave this feature for later.

Accidentally commited an empty commit, luckily I remembered that git amend was a thing 🤡.

---

Looks like I was able to get the barebones functionality done.  
Some things for tomorrow:

- add a name to each image
- resize images in `image_tag`

## Sept 16

Ok, first thing I want to do is resize some things in the HTML so that their easier to work with.  
Hmm, [looks like I `.variant` might be helpful!](https://dev.to/mikerogers0/resize-images-with-active-storage-in-rails-481n)  
Based on some [comments in the rails source](https://github.com/rails/rails/blob/main/activestorage/app/models/active_storage/variant.rb), it also looks like I need `image_processing` in my gemfile.

---

I figured ImageMagick was a gem or was distributed with rails, but its actually just an external binary.  
The variants of my images werent working (and I noticed that the size wasn't included in the metadata of the img in the db)  
Lets see if a quick `brew install imagemagick` fixes things.  
Yup, all fixed!  
Hmm, external dependencies are annoying. I'll have to look into docker-izing this project if I have time.

---

Ok with images a little more manageable, lets add some titles to these images.  
Hmm, the title is nil!

```
irb(main):007:0> Image.last
  Image Load (0.2ms)  SELECT "images".* FROM "images" ORDER BY "images"."id" DESC LIMIT ?  [["LIMIT", 1]]
=>
#<Image:0x00007fe0d55bc350
 id: 12,
 created_at: Thu, 16 Sep 2021 16:47:08.489519000 UTC +00:00,
 updated_at: Thu, 16 Sep 2021 16:47:08.508189000 UTC +00:00,
 title: nil>
```

Ah, I forgot to update the image_params!  
`params.require(:image).permit(:file)` -> `params.require(:image).permit(:file, :title)`  
Tada!

---

Before I get onto building some search functionality, I want to do some simple validation.

While trying to validate the size of the image, `file.byte_size` is yeilding something smaller than I expect.  
I suspect this is because imagemagick is resizing my images before storing them. I'll try changing the `variant`.

---

With some basic validation done its on to some tests!  
Hmm, getting an error:

```
/Users/nfg/.gem/gems/bootsnap-1.8.1/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:34:in `require': cannot load such file -- rexml/document (LoadError)
```

This is the second time I've seen this bootsnap lib file get angry about something.  
Last time it wasn't bootsnaps fault, so I'll assume the same here.  
Looks like it's having some issues loading a file. Something about rexml?  
Ah, appears like this is a [known issue](https://github.com/rails/rails/issues/41502#issuecomment-864739940) with selenium.  
Looks like pinning selenium to `4.0.0.rc1` and running `bundle update` has fixed the issue.

---

To do some tests, I need a way to fake some active storage data.  
A google search yeilds [some answers](https://stackoverflow.com/questions/50453596/activestorage-fixtures-attachments).  
Apparently I can create fixtures for both attachments and blobs and use those.  
What's nice about that is the fact that information like image type and size are stored in the blob, so I can do some tests without referencing an actual stored image!

Looks like I have the correct active storage data being generated with fixtures.  
When testing I had to check the if the actual `image.file.blob` was nil. `image.file` seems to just return the active storage attachment (for which one exists, presumably due to `has_one_attached`)

---

Looking into how to test models, [this example](https://github.com/gorails-screencasts/testing-rails-validations/blob/b3d5f3f2cd7b75bcee31f7fc7899e76d799f4254/test/models/rating_test.rb#L3-L10) details how to test the validations.

## Sept 17

Gotta test some models today!

`.create` instantiates an object, validates it, and saves it to DB. `.new` just instantiates it.  
Calling `.valid?` also triggers validations!

I'd like to attach a test-file to a new instance of an image record for some test data.  
I'm looking for an `attachable` according to the [docs](https://github.com/rails/rails/blob/83217025a171593547d1268651b446d3533e2019/activestorage/lib/active_storage/attached/one.rb#L29).  
Hmm, I can't find an explaination of what an attachable is. Luckily the [rails source](https://github.com/rails/rails/blob/83217025a171593547d1268651b446d3533e2019/activestorage/lib/active_storage/attached/one.rb#L26-L29) gives some clues.

Hmm, I might just use `File.open` instead 😈.  
Honestly a little gross, but it should work pretty good for now.  
I wonder if I can pull an image from the web and use it as test data 🤔.

Just rememered that rails runs the fixtures yaml through the ERB, so I can do stuff like this:

```
  byte_size: <%= File.size('test/fixtures/files/large.jpg') %>
  checksum: <%= Digest::MD5.file('test/fixtures/files/large.jpg').base64digest %>
```

Kinda rad.

---

Trying to test some controller stuff, but generating correct data for active storage with fixtures is tricky.  
A simple `get images_url` causes things to go haywire because the test DB isnt correctly populated with fixture data.  
I noticed that uploading an image through the typical means produces 2 images in storage.  
I suspect that this is the original and the variant image.  
Unsure how I can create fixtures for variants.

Ah, it seems this is a non issue if I [account for it in the view](https://github.com/gorails-screencasts/testing-activestorage-uploads/blob/a11b11263e46943ad09168097b0834208182d8f9/app/views/photos/show.html.erb#L5).

---

With testing done (for now), I wan't to focus on getting some basic search working.  
Fuzzy stuff is hard, so I'll try and use elasticsearch.  
This may all go terribly wrong, so I'll try this on a separate branch.

---

Got some basic string-equivalence searching done with elasticsearch!  
Now... how to make it fuzzy.
