# frozen_string_literal: true

RSpec.describe Baes do
  it "has a version number" do
    expect(Baes::VERSION).not_to be nil
  end

  it "does not allow backtick system calls" do
    message =
      "Don't use system calls. Use `Open3.capture3` instead. " \
      "Called with `echo 'blah'`"

    expect { `echo 'blah'` }
      .to raise_error(TestingError, message)
  end

  it "does not allow system calls" do
    message =
      "Don't use system calls. Use `Open3.capture3` instead. " \
      "Called with `echo 'blah'`"

    expect { system("echo 'blah'") }
      .to raise_error(TestingError, message)
  end
end
