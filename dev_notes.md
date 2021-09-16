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


