require 'spec_helper'

describe UserPostalSubscriptions do

  describe ".with_local_postal_mail_subscription" do
    subject { User.with_local_postal_mail_subscription }

    describe "for users with and without subscriptions" do
      before do
        @user_without = create :user
        @user_with_nil = create :user
        @user_with_nil.local_postal_mail_subscription = false
        @user_with_nil.save
        @user_with_subscription = create :user
        @user_with_subscription.local_postal_mail_subscription = true
        @user_with_subscription.save
      end
      it { should include @user_with_subscription }
      it { should_not include @user_without }
      it { should_not include @user_with_nil }
    end
  end

  describe "for a user" do
    before { @user = create :user }

    describe "#local_postal_mail_subscription=true" do
      subject { @user.local_postal_mail_subscription = true; @user.save }

      it "should set local_postal_mail_subscribed_at" do
        subject
        @user.local_postal_mail_subscribed_at.should be_kind_of Time
      end
    end

    describe "with subscription" do
      before { @user.local_postal_mail_subscribed_at = 10.days.ago; @user.save }

      describe "#local_postal_mail_subscription=false" do
        subject { @user.local_postal_mail_subscription = false; @user.save }

        it "should unset local_postal_mail_subscribed_at" do
          subject
          @user.local_postal_mail_subscribed_at.should == nil
        end
      end
    end
  end

end