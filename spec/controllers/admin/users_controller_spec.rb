require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  describe "GET #index" do
    context "when not signed in" do
      it "raises a routing error" do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end
  end

  context "when not an admin" do
    before do
      user = create(:user)
      controller.sign_in(user)
    end

    it "raises a routing error" do
      expect { get :index }.to raise_error ActionController::RoutingError
    end
  end

  context "when admin" do
    before do
      admin = create(:admin)
      controller.sign_in(admin)
    end

    it "renders template index" do
      get :index
      expect(response).to render_template :index
    end

    it "filters users by email" do
      u1 = create(:user, email: "test1@example.com")
      create(:user, email: "person1@example.com")
      u2 = create(:user, email: "test2@example.com")
      create(:user, email: "person2@example.com")

      get :index, q: "tESt"
      expect(assigns(:users)).to match_array([u1, u2])
    end

    it "filters users by name" do
      create(:user, profile: { first_name: "John" })
      u1 = create(:user, profile: { last_name: "Mellark" })
      create(:user, profile: { first_name: "John", last_name: "Doe" })
      u2 = create(:user, profile: { first_name: "Peter", last_name: "Mellark" })

      get :index, q: "mella"
      expect(assigns(:users)).to match_array([u1, u2])
    end
  end

  describe "GET #new" do
    context "when not signed in" do
      it "raises a routing error" do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before do
        admin = create(:admin)
        controller.sign_in(admin)
      end

      it "renders template new" do
        xhr :get, :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    let(:atts) { attributes_for(:user) }

    context "when not signed in" do
      it "raises a routing error" do
        expect { post :create, atts }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before { controller.sign_in(create(:user)) }

      it "raises a routing error" do
        expect { post :create, user: atts }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before { controller.sign_in(create(:admin)) }

      context "with valid input" do
        it "assigns a valid user" do
          xhr :post, :create, user: atts
          expect(assigns(:user)).to be_valid
        end

        it "renders template create" do
          xhr :post, :create, user: atts
          expect(response).to render_template :create
        end

        it "sends welcome email" do
          expect { xhr :post, :create, user: atts }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "when email has upper case letters" do
        it "changes it to lower case" do
          xhr :post, :create, user: atts.merge(email: "TeSt@exAmPle.com")
          expect(assigns(:user).email).to eq("test@example.com")
        end
      end

      context "with invalid input" do
        it "assigns an invalid user" do
          xhr :post, :create, user: atts.merge(email: nil)
          expect(assigns(:user)).to_not be_valid
        end
      end
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user) }

    context "when not signed in" do
      it "raises a routing error" do
        expect { get :edit, id: user.id }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before { controller.sign_in(create(:user)) }

      it "raises a routing error" do
        expect { get :edit, id: user.id }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before do
        admin = create(:admin)
        controller.sign_in(admin)
      end

      it "renders template new" do
        xhr :get, :edit, id: user.id
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:atts) { attributes_for(:user) }

    context "when not signed in" do
      it "raises a routing error" do
        expect { patch :update, id: user.id }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before { controller.sign_in(create(:user)) }

      it "raises a routing error" do
        expect { patch :update, id: user.id, user: atts }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before { controller.sign_in(create(:admin)) }

      context "with invalid input" do
        it "is not valid" do
          xhr :patch, :update, id: user.id, user: atts.merge(email: nil)

          expect(assigns(:user)).to_not be_valid
        end
      end
    end
  end
end
