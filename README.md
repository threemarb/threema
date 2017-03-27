# threema

[![Build Status](https://travis-ci.org/thorsteneckel/threema.svg?branch=master)](https://travis-ci.org/thorsteneckel/threema)
[![codecov](https://codecov.io/gh/thorsteneckel/threema/branch/master/graph/badge.svg)](https://codecov.io/gh/thorsteneckel/threema)
[![Code Climate](https://codeclimate.com/github/thorsteneckel/threema/badges/gpa.svg)](https://codeclimate.com/github/thorsteneckel/threema)
[![Gem](https://img.shields.io/gem/v/threema.svg?maxAge=2592000)]()


This gem provides access to the Threema Gateway API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'threema'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install threema

## Usage

### Account creation

First of all make sure you have an account registered for the Threema Gateway. Use the [sign up form](https://gateway.threema.ch/de/signup).

To use the End To End encryption you have to [register an additional custom Threema ID](https://gateway.threema.ch/de/id-request?type=advanced). If you have no key pair (private and public) yet you can create one via:

```ruby
require 'threema'

pair = Threema::E2E::Key.generate_pair

p pair
```

**ATTENTION:** These are your identification. If you lose or publish your private key you lose your identitiy and have major problem. So keep your private key secure under all circumstances! Don't push it to a git repository or any other public place.

It is important to use the corrosponding private key for the public key you have used to register your custom Threema ID.

To receive Threema Gateway messages you need a valid HTTPS callback endpoint which Threema will call on incomming messages. Taken from the [documentation](https://gateway.threema.ch/de/developer/api):

```
Callback results and retry

If the connection to your callback URL fails or your callback does not return an HTTP 200 status, the API will retry 3 more times in intervals of 5 minutes. If all attempts fail, the message is discarded.
```

So make sure your endpoint is valid and accessable! The received payload can be handled via the gem. This is described down below in the receiving block.

After the registration process is completed and Threema activated your custom Threema ID you now should have the following credentials:

- API Identity (Custom Threema ID like e.g. `*YOURAPP1`)
- API Secret (gained from `https://gateway.threema.ch/de/id/*YOURAPP1`)
- Private Key (the one created above)

### Gem

First of all create a threema instance with the gained credentials (above) via:

```ruby
require 'threema'

threema = Threema.new(
  api_identity: api_identity,
  api_secret:   api_secret,
  private_key:  private_key
)
```

However it's recommended to use environmental variables for this. So something like this will work:

```ruby
# api_identity is stored in ENV['THREEMARB_API_IDENTITY']
# api_secret is stored in ENV['THREEMARB_API_SECRET']
# private_key is stored in ENV['THREEMARB_PRIVATE']
require 'threema'

threema = Threema.new()
```

By default HTTP Public Key Pinning is enabled to ensure the validity of the Threema Gateway HTTPS certificate. However in those special moments it might be necessary to disable it. Please do this only if you know what you are doing!

```ruby
require 'threema'

threema = Threema.new(
  public_key_pinning: false,
)
```

#### Sending

With this gem you can send simple (unencrypted!) or end to end encrypted messages.

##### Simple

Send simple (unencrypted!) messages via:

```ruby
# Threema ID
threema.send(
  type: :simple,
  to:   receiver_threema_id,
  text: hello_world,
)

# Phone
threema.send(
  type:  :simple,
  phone: '41791234567',
  text:  hello_world,
)

# Email
threema.send(
  type:  :simple,
  email: 'test@threema.ch',
  text:  hello_world,
)
```

##### Text

Send (e2e encrypted) text messages via:

```ruby
threema.send(
  type: :text,
  to:   receiver_threema_id,
  text: hello_world,
)
```

##### Image

Send (e2e encrypted) image messages via:

```ruby

# via path to file
threema.send(
  type: :image,
  to:   receiver_threema_id,
  image: '/path/to/image.png',
)

# with bytestring
threema.send(
  type: :image,
  to:   receiver_threema_id,
  image: 'imagecontent'.b,
)
```

##### File

Send (e2e encrypted) file messages via:

```ruby

# via path to file
threema.send(
  type: :file,
  to:   receiver_threema_id,
  file: '/path/to/file.txt',
)

# with bytestring
threema.send(
  type: :file,
  to:   receiver_threema_id,
  file: 'filecontent'.b,
)

# with thumbnail path
threema.send(
  type:      :file,
  to:        receiver_threema_id,
  file:      '/path/to/file.txt',
  thumbnail: '/path/to/thumbnail.png',
)

# with thumbnail bytestring
threema.send(
  type:      :file,
  to:        receiver_threema_id,
  file:      '/path/to/file.txt',
  thumbnail: 'thumbnailcontent'.b,
)
```

#### Receiving

With this gem you can receive end to end encrypted messages. To decrypt a received payload that was send to your HTTPS callback endpoint you can call the threema instance like this:

```ruby
message = threema.receive(
  payload: payload,
)
```

`message` will then be an instance of one of the following classes:

- Threema::Receive::Text
- Threema::Receive::Image
- Threema::Receive::File

You can access the message content via `message.content` which will contain either a text or bytestring, depending on the message type. File messages also have a `message.mime_type`.

## TODO

- [ ] Improve documentation
- [ ] Improve `libsodium` dependency to support either gem `rbnacl-libsodium` or self compiled
- [ ] Fix [CodeClimate issues](https://codeclimate.com/github/thorsteneckel/threema/issues)
- [ ] Make `.rubocop_todo.yml` obsolete
- [ ] Implement other send/receive message types (geo, video, audio, survey_meta, survey_state, delivery_receipt)

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake spec` to run the tests. Make sure to not reduce the test coverage.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thorsteneckel/threema.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

