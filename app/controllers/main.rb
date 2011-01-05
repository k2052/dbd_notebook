DbdNotebook.controllers :main do     
  
  get :about, :map => '/about' do
    render 'other/about'
  end     
  
end