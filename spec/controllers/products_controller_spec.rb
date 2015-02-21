require 'rails_helper'

describe ProductsController do
  describe 'GET #index' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'populates an array of products' do
        product = FactoryGirl.create(:product)
        @user.products << product
        get :index
        expect(assigns(:products)).to eq(@user.products)
      end

      it 'renders the :index view' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @product = FactoryGirl.create(:product)
      end

      it 'assigns the requested product to @product' do
        @user.products << @product
        get :show, id: @product
        expect(assigns(:product)).to eq(@product)
      end

      it 'renders the :show view' do
        @user.products << @product
        get :show, id: @product
        expect(response).to render_template(:show)
      end

      it 'raises error if @user does not own requested product' do
        expect { get :show, id: @product }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :show, id: FactoryGirl.create(:product)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #new' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'assigns a new Product to @product' do
        get :new
        expect(assigns(:product)).to be_a_new(Product)
      end

      it 'assigns @product to current user' do
        get :new
        expect(assigns(:product).user_id).to eq(@user.id)
      end

      it 'renders the :new view' do
        expect(get :new).to render_template(:new)
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes (guest user)' do
      it 'does not save the product to the database' do
        expect do
          post :create, product: FactoryGirl.attributes_for(:product)
        end.to_not change(Product, :count)
      end
    end

    context 'with valid attributes (signed in)' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'saves the new product to the database' do
        expect do
          post :create, product: FactoryGirl.attributes_for(:product)
        end.to change(Product, :count).by(1)
      end

      it 'redirects to the :index view' do
        post :create, product: FactoryGirl.attributes_for(:product)
        expect(response).to redirect_to products_path
      end
    end

    context 'with invalid attributes (signed in)' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'does not save the new product to the database' do
        expect do
          post :create, product: FactoryGirl.attributes_for(:invalid_product)
        end.to_not change(Product, :count)
      end

      it 're-renders the :new view' do
        post :create, product: FactoryGirl.attributes_for(:invalid_product)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @product = FactoryGirl.create(:product)
      end

      context 'who owns product' do
        before :each do
          @user.products << @product
        end

        it 'assigns requested product to @product' do
          get :edit, id: @product
          expect(assigns(:product)).to eq(@product)
        end

        it 'renders the :edit view' do
          expect(get :edit, id: @product).to render_template(:edit)
        end
      end

      context 'who does not own product' do
        it 'raises error' do
          expect { get :edit, id: @product }.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :edit, id: FactoryGirl.create(:product)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @product = FactoryGirl.create(:product, description: 'description')
    end

    context 'when logged in' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context 'and owner of product' do
        before :each do
          @user.products << @product
        end

        context 'with valid attributes' do
          it 'locates the requested product' do
            put :update, id: @product, product: FactoryGirl.attributes_for(:product)
            expect(assigns(:product)).to eq(@product)
          end

          it 'changes products attributes' do
            put :update, id: @product, product: FactoryGirl.attributes_for(:product, description: 'Edited', unit: 'liter')
            @product.reload
            expect(@product.description).to eq('Edited')
            expect(@product.unit).to eq('liter')
          end

          it 'redirects to :index view' do
            put :update, id: @product, product: FactoryGirl.attributes_for(:product)
            expect(response).to redirect_to(products_path)
          end
        end

        context 'with invalid attributes' do
          it 'locates the requested product' do
            put :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
            expect(assigns(:product)).to eq(@product)
          end

          it 'does not change products attributes' do
            put :update, id: @product, product: FactoryGirl.attributes_for(:product, description: nil, unit: 'liter')
            @product.reload
            expect(@product.description).to eq('description')
            expect(@product.unit).to_not eq('liter')
          end

          it 're-renders the :edit view' do
            put :update, id: @product, product: FactoryGirl.attributes_for(:invalid_product)
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'and not owner of product' do
        it 'raises record not found error' do
          expect do
            put :update, id: @product, product: FactoryGirl.attributes_for(:product)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    context 'when guest' do
      it 'does not change product attributes' do
        put :update, id: @product, product: FactoryGirl.attributes_for(:product, description: 'hello', unit: 'liter')
        @product.reload
        expect(@product.description).to eq('description')
        expect(@product.unit).to_not eq('liter')
      end

      it 'redirects to login' do
        put :update, id: @product, product: FactoryGirl.attributes_for(:product)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @user = FactoryGirl.create(:user)
      @product = FactoryGirl.create(:product)
    end

    context 'for signed in user' do
      before :each do
        sign_in @user
      end

      it 'raises error if user is not owner of product' do
        expect { delete :destroy, id: @product }.to raise_error(CanCan::AccessDenied)
      end

      it 'deletes the product' do
        @user.products << @product
        expect { delete :destroy, id: @product }.to change(Product, :count).by(-1)
      end

      it 'redirects to products#index after delete' do
        @user.products << @product
        delete :destroy, id: @product
        expect(response).to redirect_to products_path
      end
    end

    context 'for guest user' do
      it 'redirects to login' do
        delete :destroy, id: @product
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #product_json' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @product = FactoryGirl.create(:product, description: 'Even skaper ro')
      end

      it 'returns the correct product' do
        @user.products << @product
        get :product_json, id: @product
        expect(response.body).to include('Even skaper ro')
      end

      it 'raises error if user is not owner of product' do
        expect { get :product_json, id: @product }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        user = FactoryGirl.create(:user)
        product = FactoryGirl.create(:product, description: 'Even skaper ro')
        user.products << product
        get :product_json, id: product
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
