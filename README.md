# Webhookr::Recurly

[![Build Status](https://travis-ci.org/tfe/webhookr-recurly.png?branch=master)](https://travis-ci.org/tfe/webhookr-recurly)
[![Dependency Status](https://gemnasium.com/tfe/webhookr-recurly.png)](https://gemnasium.com/tfe/webhookr-recurly)
[![Code Climate](https://codeclimate.com/github/tfe/webhookr-recurly.png)](https://codeclimate.com/github/tfe/webhookr-recurly)

This gem is a plugin for [Webhookr](https://github.com/zoocasa/webhookr) that enables
your application to accept [webhooks from Recurly](https://docs.recurly.com/push-notifications).

## Installation

Add this line to your application's Gemfile:

    gem 'webhookr-recurly'

Or install it yourself:

    $ gem install webhookr-recurly

## Usage

Once you have the gem installed, run the generator to add the engine route to your config/routes.rb:

```console
rails g webhookr:add_route
```

or, add the routing information manually to config/routes.rb

```ruby
mount Webhookr::Engine => "/webhookr", :as => "webhookr"
```

Then run the generator to add the code to your initializer.
An initializer will be created if you do not have one.

```console
rails g webhookr:recurly:init *initializer_name* -s
```

Run the generator to create an example file to handle Recurly webhooks.

```console
rails g webhookr:recurly:example_hooks
```

Or create a Recurly handler class for any event that you want to handle. For example
to handle unsubscribes you would create a class as follows:

```ruby
class RecurlyHooks
  def canceled_subscription_notification(incoming)
    # Your custom logic goes here.
    User.sync_recurly_subscription(incoming.payload.account.account_code)
  end
end
```

For a complete list of events, and the payload format, see below.

Edit config/initializers/*initializer_name* and change the commented line to point to
your custom Recurly event handling class. If your class was called *RecurlyHooks*
the configuration line would look like this:

```ruby
  Webhookr::Recurly::Adapter.config.callback = RecurlyHooks
```

To see the list of Recurly URLs for your application can use when you configure
Recurly webhooks (https://[yoursite].recurly.com/configuration/notifications),
run the provided webhookr rake task:

```console
rake webhookr:services
```

Example output:

```console
recurly:
  GET	/webhookr/events/recurly/19xl64emxvn
  POST	/webhookr/events/recurly/19xl64emxvn
```

## Recurly Events & Payload

### Events

All webhook events are supported. For further information on events, see the
[Recurly documentation](https://docs.recurly.com/api/push-notifications).

### Payload

The payload is the full payload data from as per the [Recurly
documentation](https://docs.recurly.com/api/push-notifications), converted to an
OpenStruct for ease of access. Examples for the subscription canceled webhook:

```ruby
  incoming.payload.account.account_code
  incoming.payload.account.email
  incoming.payload.subscription.state
  incoming.payload.subscription.canceled_at
  incoming.payload.subscription.expires_at
  incoming.payload.subscription.plan.plan_code
  incoming.payload.subscription.plan.name
```

### Versioning
This library aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). Violations of this scheme should be reported as
bugs. Specifically, if a minor or patch version is released that breaks backward compatibility, that
version should be immediately yanked and/or a new version should be immediately released that restores
compatibility. Breaking changes to the public API will only be introduced with new major versions. As a
result of this policy, once this gem reaches a 1.0 release, you can (and should) specify a dependency on
this gem using the [Pessimistic Version Constraint](http://docs.rubygems.org/read/chapter/16#page74) with
two digits of precision. For example:

    spec.add_dependency 'webhookr-recurly', '~> 1.0'

While this gem is currently a 0.x release, suggestion is to require the exact version that works for your code:

    spec.add_dependency 'webhookr-recurly', '0.1'

## License

webhookr-recurly is released under the [MIT license](http://www.opensource.org/licenses/MIT).

## Authors

* [Todd Eichel](https://github.com/tfe)
* [Gerry Power](https://github.com/gerrypower)
