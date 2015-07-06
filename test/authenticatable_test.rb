require "test_helper"

class AuthenticatableTest < MiniTest::Spec
  Authenticatable = Tyrant::Authenticatable
  User = Struct.new(:auth_meta_data)

  describe "#confirmable?" do
    # nothing initialized.
    it { Authenticatable.new(User.new).confirmable?.must_equal false }
    it { Authenticatable.new(User.new({})).confirmable?.must_equal false }
    it { Authenticatable.new(User.new({confirmation_token: nil})).confirmable?.must_equal false }
    # token given.
    it { Authenticatable.new(User.new({confirmation_token: "yo!"})).confirmable?.must_equal true }


    it { Authenticatable.new(User.new({})).confirmable?("yo!").must_equal false }
    it { Authenticatable.new(User.new({confirmation_token: "yo!"})).confirmable?("yo!").must_equal true }
    # TODO: add expiry.
  end

  describe "#confirmable!" do
    it do
      auth = Authenticatable.new(User.new)
      auth.confirmable?.must_equal false
      auth.confirmable!.must_equal auth
      auth.confirmable?.must_equal true
      auth.auth_meta_data.confirmation_token.must_be_kind_of String
    end
  end

  describe "#confirmed? / #cofirm!" do
    # blank.
    it { Authenticatable.new(User.new).confirmed?.must_equal false }
    # with token.
    it { Authenticatable.new(User.new({confirmation_token: "yo!"})).confirmed?.must_equal false }

    it do
      auth = Authenticatable.new(User.new({confirmation_token: "yo!"}))
      auth.confirm!
      # confirmed?
      auth.confirmed?.must_equal true
      # confirmed_at.
      auth.auth_meta_data.confirmed_at.must_be_kind_of DateTime
    end
  end

  describe "#confirmation_token" do
    it do
      auth = Authenticatable.new(User.new)
      auth.confirmation_token.must_equal nil
      auth.confirmable!
      auth.confirmation_token.must_be_kind_of String
    end
  end
end