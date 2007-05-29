require File.dirname(__FILE__) + '/../test_helper'
require 'auctions_controller'

# Re-raise errors caught by the controller.
class AuctionsController; def rescue_action(e) raise e end; end

class AuctionsControllerTest < Test::Unit::TestCase
  fixtures :auctions

  def setup
    @controller = AuctionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:auctions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_auction
    old_count = Auction.count
    post :create, :auction => { }
    assert_equal old_count+1, Auction.count
    
    assert_redirected_to auction_path(assigns(:auction))
  end

  def test_should_show_auction
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_auction
    put :update, :id => 1, :auction => { }
    assert_redirected_to auction_path(assigns(:auction))
  end
  
  def test_should_destroy_auction
    old_count = Auction.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Auction.count
    
    assert_redirected_to auctions_path
  end
end
