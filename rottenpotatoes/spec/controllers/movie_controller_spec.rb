require 'rails_helper'

describe MoviesController, type: :controller do
  describe '#similar' do
    before :each do
      @id1 = '1'
      @id2 = '2'
      @id3 = '3'
      @director1 = 'The Unknown Director'
      @director2 = nil
      @director3 = nil
      @movie1 = double('movie1')
      @movie2 = double('movie2')
      @movie3 = double('movie3', :title => 'Alien')
      @results = [@movie1, @movie2]
    end
    context 'When movie record has a director' do
      describe 'When searching for movie the same director' do
        it 'calls the find method to retrieve the movie' do
          expect(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
        end
        it 'calls the director getter on the movie' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          expect(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
          expect(assigns(:director)).to eq(@director1)
        end
        it 'makes retrieved director available' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
          expect(assigns(:director)).to eq(@director1)
        end
        it 'calls the model method to find similar movies' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          expect(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
        end
        it 'selects the Same Director template for rendering' do
           allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
           allow(@movie1).to receive(:director).and_return(@director1)
           allow(@movie1).to receive(:find_with_same_director).and_return(@results)
           get :similar, :id => @id1
           expect(response).to render_template('similar')
           #get :similar, :id => @id1
        end
        it 'makes the results available to the template' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
          expect(assigns(:movies)).to eq(@results)
        end
      end
    end
    context 'When movie record has no director' do
      describe 'When searching for movie with same director' do
        it 'Checks to see if director has no value' do
         # allow_message_expectations_on_nil
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          expect(@director3).to be_blank
          allow(@movie3).to receive(:title)
          get :similar, :id => @id3
         # expect(assigns(:director)).to be_nil
        end
=begin
        it 'makes the director available' do
         # allow_message_expectations_on_nil
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          allow(@director3).to be_blank
          get :similiar, :id =>@id3
         # expect(assigns(:director)).to be_nil
        end
=end
        it 'Sets a flash message' do
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          get :similar, :id => @id3
          expect(flash[:warning]).to eq("'#{@movie3.title}' has no director info")
        end
        it 'Redirects to the movies page' do
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          allow(@movie3).to receive(:title)
          get :similar, :id => @id3
          expect(response).to redirect_to(movies_path)
        end
      end
    end
  end
end


        