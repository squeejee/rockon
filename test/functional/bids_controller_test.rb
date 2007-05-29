require File.dirname(__FILE__) + '/../test_helper'
require 'bids_controller'

# Re-raise errors caught by the controller.
class BidsController; def rescue_action(e) raise e end; end

class BidsControllerTest < Test::Unit::TestCase
  fixtures :bids

  def setup
    @controller = BidsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:bids)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_bid
    old_count = Bid.count
    post :create, :bid => { }
    assert_equal old_count+1, Bid.count
    
    assert_redirected_to bid_path(assigns(:bid))
  end

  def test_should_show_bid
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_bid
    put :update, :id => 1, :bid => { }
    assert_redirected_to bid_path(assigns(:bid))
  end
  
  def test_should_destroy_bid
    old_count = Bid.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Bid.count
    
    assert_redirected_to bids_path
  end
end
