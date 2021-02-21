require 'spec_helper'
require 'link_to_active_state/view_helpers/url_helper'

module App
  class Helper < ActionView::Base
    include LinkToActiveState::ViewHelpers::UrlHelper
  end
end

describe LinkToActiveState::ViewHelpers::UrlHelper do
  let(:helper) { App::Helper.new(ActionView::LookupContext.new([Pathname.new(__dir__).to_s]), {}, nil) }

  let(:request) do
    class Request
      def fullpath
      end
    end

    Request.new
  end

  before(:each) do
    helper.stub(:request).and_return(request)
  end

  context "integration with ActionView" do
    it "aliases the original link_to helper" do
      helper.should respond_to(:link_to_without_active_state)
    end

    it "responds to link_to_with_active_state" do
      helper.should respond_to(:link_to_with_active_state)
    end

    it "aliases link_to_with_active_state to link_to" do
      lt = helper.link_to "Test", "/", :active_on => proc { true }
      ltwas = helper.link_to_with_active_state "Test", "/", :active_on => proc { true }
      ltwoas = helper.link_to_without_active_state "Test", "/", :active_on => proc { true }
      lt.should eq(ltwas)
      lt.should_not eq(ltwoas)
    end
  end

  context "active states on links" do
    context "when the current request path matches" do
      it "adds an active state" do
        request.stub(:fullpath).and_return("/")
        lt = helper.link_to "Home", "/", :active_on => "/"
        lt.should match(/class=\"active\"/i)
      end

      it "uses the link's URL by default" do
        request.stub(:fullpath).and_return("/")
        lt = helper.link_to "Home", "/", :active_on => true
        lt.should match(/class=\"active\"/i)
      end

      it "encloses link in an element with active state if active_wrapper is true" do
        request.stub(:fullpath).and_return("/")
        lt = helper.link_to "Home", "/", :active_on => "/", :active_wrapper => :li
        lt.should match(/li class=\"active\"/i)
      end

      it "doesn't enclose link in an element if active_wrapper is not specified" do
        request.stub(:fullpath).and_return("/")
        lt = helper.link_to "Home", "/", :active_on => "/"
        lt.should_not match(/li class=\"active\"/i)
      end

      it "matches in spite of query string if ignore query is true" do
        request.stub(:fullpath).and_return("/wobble?test=true")
        lt = helper.link_to "Madness", "/wobble", :active_on => true, :ignore_query => true
        lt.should match(/class=\"active\"/i)
      end

      it "doesn't match in spite of query string if ignore query is not specified" do
        request.stub(:fullpath).and_return("/wobble?test=true")
        lt = helper.link_to "Madness", "/wobble", :active_on => true
        lt.should_not match(/class=\"active\"/i)
      end
    end

    context "when the current request doesn't match" do
      it "doesn't add an active state" do
        request.stub(:fullpath).and_return("/wibble")
        lt = helper.link_to "Madness", "/wobble", :active_on => "/wobble"
        lt.should_not match(/class=\"active\"/i)
      end

      it "encloses link in an element if active_wrapper is true" do
        request.stub(:fullpath).and_return("/wibble")
        lt = helper.link_to "Home", "/", :active_on => "/", :active_wrapper => :li
        lt.should match(/<li>/i)
      end
    end

    describe "wrapper element" do
      it "supports options for the wrapper element" do
        li = helper.link_to "Home", "/",
          :class => "wobble",
          :active_on => "/",
          :active_wrapper => :li,
          :active_wrapper_options => { :class => "wibble" }
        li.should match(/class=\"wibble\"/i)
      end

      it "supports a proc as the wrapper element" do
        request.stub(:fullpath).and_return("/")
        li = helper.link_to "Home", "/",
          :class => "wobble",
          :active_on => "/",
          :active_wrapper => proc { |link, wrapper_options|
            "<li class=\"#{wrapper_options[:class]}\">#{link}</li>"
          }
        li.should match(/<li class=\"active\">/i)
        li.should match(/<a class=\"wobble\" href/i)
      end

      it "supports options on proc wrapper elements" do
        request.stub(:fullpath).and_return("/")
        li = helper.link_to "Home", "/",
          :class => "wobble",
          :active_on => "/",
          :active_wrapper_options => { :class => "wibble" },
          :active_wrapper => proc { |link, wrapper_options|
            "<li class=\"#{wrapper_options[:class]}\">#{link}</li>"
          }
        li.should match(/<li class=\"wibble active\">/i)
      end
    end
  end
end
