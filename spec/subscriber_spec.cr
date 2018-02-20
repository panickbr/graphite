require "./spec_helper"

describe Graphite::Subscriber do
  context "when two publishers" do
    pub = Pub.new
    pub2 = Pub.new
    sub = Sub.new

    describe "#on_notify" do
      pub.on_output << sub
      pub2.on_output << sub
      test_string_1 = "Publisher 1 called."
      test_string_2 = "Publisher 2 called."

      Spec.before_each do
        sub.string = ""
        sub.bool = false
      end

      it "gets called from the same event on different publishers" do
        pub.output test_string_1
        sub.string.should eq(test_string_1)
        pub2.output test_string_2
        sub.string.should eq(test_string_2)
      end

      it "gets called from different events" do
        pub2.on_bool_changed << sub

        pub.output test_string_1
        pub2.change_bool

        sub.string.should eq(test_string_1)
        sub.bool.should be_true
      end
    end
  end
end
