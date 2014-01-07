require "cios_helpers/version"
require "calabash-cucumber/ibase"

module CiosHelpers

    # Performs a lambda action until the element appears.
    # The default action is to do nothing.
  def until_element_exists opts = {}
    raise "No element given." if opts[:element].nil?
    timeout = opts[:timeout] || 10
    action = opts[:action] || lambda { ; }
    wait_poll until_exists: opts[:element], timeout: timeout do
      action.call
    end
  end

    # Performs a lambda action once the element exists.
    # The default behavior is to touch the specified element.
  def once_element_exists opts = {}
    raise "No element given." if opts[:element].nil?
    timeout = opts[:timeout] || 10
    action = opts[:action] || lambda { touch opts[:element] }
    wait_for_elements_exist [opts[:element]], timeout: timeout
    action.call
  end

    # Pass an array of query elements. Determines the
    # correct trait for page objects that can have multiple 
    # acceptable traits.
  def multiple_traits opts = {}
    timeout = opts[:timeout] || 10
    traits = opts[:traits] || ["*"]
    trait = ''
    action = lambda do 
      traits.each do |element|
        if element_exists element
          trait = element
          break
        end
      end
      !trait.empty?
    end
    wait_poll until: action, timeout: timeout do ; end
    trait # Return the one trait
  end

    # Takes in a hash with the element key specified. 
    # Touches the given element if it exists in the 
    # current view.
  def touch_if opts = {}
    raise "No element given." if opts[:element].nil?
    touch opts[:element] if element_exists opts[:element]
  end

    # Takes in an array of strings.
    # Enters in the strings in order of 
    # the TextField indices.
  def enter_text_by_index arr = []
    arr.each_with_index do |string, index|
      unless query("TextField index:#{index}").empty?
        touch "TextField index:#{index}"
        wait_for_elements_exist ["Keyboard"]
        keyboard_enter_text string
      end
    end
  end

    # Takes in a hash where the keys
    # correspond to the ids or label of the 
    # text fields and the values correspond
    # to the strings you want to enter.
  def enter_text opts = {}
    opts.each do |key, value|
      unless query("TextField marked:'#{key}'").empty?
        touch "TextField marked:'#{key}'"
        wait_for_elements_exist ["Keyboard"]
        keyboard_enter_text value
      end
    end
  end

end
