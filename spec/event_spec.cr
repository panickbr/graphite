require "./spec_helper"

describe Graphite::Event do
  context "when one publisher" do
    # Considering on_output as Graphite::Event
    pub = Pub.new
    sub = Sub.new
    sub2 = Sub.new

    describe "#add" do
      Spec.before_each do
        pub.on_output.remove_all
        pub.on_output.subs.size.should eq(0)
      end

      it "subscribes a observer" do
        pub.on_output.add sub

        pub.on_output.subs.size.should eq(1)
        pub.on_output.subs.should contain(sub)
      end

      it "works with << alias" do
        pub.on_output << sub

        pub.on_output.subs.size.should eq(1)
        pub.on_output.subs.should contain(sub)
      end

      it "subscribes an observer only one time" do
        pub.on_output << sub
        pub.on_output << sub

        pub.on_output.subs.size.should eq(1)
        pub.on_output.subs.should contain(sub)
      end

      it "subscribes multiple observers" do
        pub.on_output << sub
        pub.on_output << sub2

        pub.on_output.subs.size.should eq(2)
        pub.on_output.subs.should contain(sub)
        pub.on_output.subs.should contain(sub2)
      end
    end

    describe "#remove" do
      Spec.before_each do
        pub.on_output << sub
        pub.on_output.subs.size.should eq(1)
      end

      it "removes a subscriber" do
        pub.on_output.remove sub

        pub.on_output.subs.size.should eq(0)
        pub.on_output.subs.should_not contain(sub)
      end
    end

    describe "#fire" do
      test_string = "#on_notify called"

      # Considering a.output as calling on_output.fire
      Spec.before_each do
        pub.on_output << sub
      end

      it "calls #on_notify" do
        sub.string = ""

        pub.output test_string
        sub.string.should eq(test_string)
      end

      it "does not call #on_notify on non subscribers" do
        sub.string = ""
        pub.on_output.remove sub

        pub.output test_string

        sub.string.should_not eq(test_string)
      end

      it "calls #on_notify on multiple subscribers" do
        sub2.string = ""
        sub.string = ""
        pub.on_output << sub2

        pub.output test_string

        sub.string.should eq(test_string)
        sub2.string.should eq(test_string)
      end
    end
  end
end
