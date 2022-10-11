# Baes

Welcome to your new gem! In this directory, you'll find the files you need to
be able to package up your Ruby library into a gem. Put your Ruby code in the
file `lib/baes`. To experiment with that code, run `bin/console` for an
interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'baes'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install baes

## Usage

TODO: Write usage instructions here

### Anatomy of a Rebase

Let’s imagine we have the following chain of branches:

```
main
  branch_01 # based on main
    branch_02 # based on branch_01
      branch_03 # based on branch_02
```

We can say the top commit on `main` has hash `m1`. `branch_01` will have `a1`,
`branch_02` will have `a1,b1`, and `branch_03` has `a1,b1,c1`.

Now let’s say we rebase merge `branch_01` onto `main`. If we rebase or squash
commits onto another branch, it actually generates a _new_ commit hash, even if
the code changes are the same. So `main` will have hashes `m1,a2`, where `a2`
is a new hash for the same changes as `a1`. In this scenario, `branch_02` will
still have commits `a1,b1` even though `main` has an equivalent commit `a2`. So
what do we do? We rebase!

```
git rebase main branch_02
```

There are a series of possible outcomes.

1. It tosses commit `a1` because it has no changes from what is on `main`. Here
   we are left with a new `b2` commit hash on `branch_02`.
2. Maybe you made some slight changes to `branch_01` based on feedback. When
   you rebase you end up with a conflict! Well, in this case the conflict is
   easy to resolve if it’s on `a1`. You simply skip it since you only care
   about commit `b1`: `git rebase --skip`. Then you again end up with `b2`, or
   maybe you have a conflict there as well, which you will need to resolve
   manually and use `git rebase --continue`.
3. Maybe you made some major changes to `branch_01` based on feedback. Because
   of this there is no overlap between the new `a2` on `main` and the `a1` on
   `branch_02`. When you rebase `branch_02` on `main`, it cleanly applies the
   changes, leaving you with `a3,b2` on `branch_02`. This is the least optimal
   scenario, since you probably want commit `a3` to go away. You’ll need to do
   do an interactive rebase `git rebase -i main branch_02` and manually delete
   that commit. Thankfully, this doesn’t seem to happen all that often.

`baes` helps you easily address the first two cases. It rebases _all_ of your
branches on the base branch (`main` by default). If it hits a conflict in the
process, it will prompt you to skip this step in the rebase. If we are
confident we only have one commit on our branch that we care about, we can skip
up to the top commit:

```
$ baes
conflict rebasing branch branch_01 on main
skip commit 1 of 2? (y/n) y
conflict rebasing branch branch_01 on main
skip commit 2 of 2? (y/n) n
```

Then we fix the code and run `git rebase --continue`. This enables you to have
long chains of branches without nearly as much of the tedium of handling rebase
conflicts. If that’s still not fast enough for you and you’re feeling daring,
you can run with the `--auto-skip` flag, which will automatically skip and only
stop on the top commit. This has the caveats that 1) you should be sure you
only have one commit on each branch and 2) you don’t have any one-off branches
with a bunch of commits that might conflict, as it’ll skip those. The upshot is
that on a branch like that you’ll probably end up with conflicts on the last
commit as well, so you’ll be able to abort the rebase process (`git rebase
--abort`) and restart it from scratch to handle the conflicts manually.

Once all your branches are rebased, you can clean up any that are up to date
with `main`:

```
git checkout main && git branch --merged | grep -v "\(main\|master\|staging\)" | xargs -r git br -d
```

You can find a more aggressive git cleanup helper [here][gc].

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/baes. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [code of
conduct](https://github.com/[USERNAME]/baes/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Baes project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/baes/blob/main/CODE_OF_CONDUCT.md).

[gc]: https://github.com/mockdeep/dotfiles/blob/414c34b6a35dd512c88fa86d4d1f896f603a5af2/bash/aliases#L123-L129
