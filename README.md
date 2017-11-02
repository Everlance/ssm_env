# SsmEnv

This gem is meant to fetch string and encrypted string parameters from AWS SSM and store them either in a file or in the local environment.
## Pre Install

Ensure you have AWS access variables configured for use with the Ruby SDK, as defined in the V2 Ruby SDK Docs - http://docs.aws.amazon.com/sdkforruby/api/
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ssm_env'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ssm_env

## Usage

#### Use this from the command line like 

**Output Values**
```
ssm_env show -i "[BRANCH_KEY, VACUUM_RATE]"
ssm_env show -i ssm_param_names.yml
```

**Synch your environment**
```
ssm_env sync -i "[BRANCH_KEY, VACUUM_RATE]"
ssm_env sync -i ssm_param_names.yml
```

#### Use this in ruby like 
```
ssm_env = SsmEnv.new.run(params_list: [BRANCH_KEY, VACUUM_LIMIT])
# Update the environment
ssm_env.to_env 
# Store in a file
ssm_env.to_file('/tmp/my_vars.env')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Everlance/ssm_env.

