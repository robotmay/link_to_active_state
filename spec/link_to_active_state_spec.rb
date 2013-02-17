require 'spec_helper'
require 'link_to_active_state/view_helpers/url_helper'

module App
  class Helper < ActionView::Base
    include LinkToActiveState::ViewHelpers::UrlHelper
  end
end

describe LinkToActiveState::ViewHelpers::UrlHelper do
  let(:helper) { App::Helper.new }

  context "integration with ActionView" do
    it "aliases the original link_to helper" do
      helper.should respond_to(:link_to_without_active_state)
    end

    it "responds to link_to_with_active_state" do
      helper.should respond_to(:link_to_with_active_state)
    end

    it "aliases link_to_with_active_state to link_to" do
      lt = helper.link_to "Test", "/", :active_on => lambda { true }
      ltwas = helper.link_to_with_active_state "Test", "/", :active_on => lambda { true }
      ltwoas = helper.link_to_without_active_state "Test", "/", :active_on => lambda { true }
      lt.should eq(ltwas)
      lt.should_not eq(ltwoas)
    end
  end

  context "active states on links" do
    let(:request) do
      class Request
        def fullpath
        end
      end

      Request.new
    end

    before(:each) do
      helper.stub!(:request).and_return(request)
    end

    context "when the current request path matches" do

      it "adds an active state" do
        request.stub!(:fullpath).and_return("/")
        lt = helper.link_to "Home", "/", :active_on => "/"
        lt.should match(/class=\"active\"/i)
      end

      it "encloses link in an li with active state if with_li is true" do
        request.stub!(:fullpath).and_return("/")
        lt = helper.link_to "Home", "/", :active_on => "/", :with_li => true
        lt.should match(/li class=\"active\"/i)
      end

      it "doesn't enclose link in an li if with_li is not specified" do
        request.stub!(:fullpath).and_return("/")
        lt = helper.link_to "Home", "/", :active_on => "/"
        lt.should_not match(/li class=\"active\"/i)
      end
    end

    context "when the current request doesn't match" do
      it "doesn't add an active state" do
        request.stub!(:fullpath).and_return("/wibble")
        lt = helper.link_to "Madness", "/wobble", :active_on => "/wobble"
        lt.should_not match(/class=\"active\"/i)
      end

      it "encloses link in an li if with_li is true" do
        request.stub!(:fullpath).and_return("/wibble")
        lt = helper.link_to "Home", "/", :active_on => "/", :with_li => true
        lt.should match(/<li>/i)
      end

    end

  end
end
