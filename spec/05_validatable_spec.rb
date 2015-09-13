describe 'Validatable' do 

  describe '#validates presence' do
    before(:each) do
      class Cat < SQLObject
        validates(:name, { presence: true })

        self.finalize!
      end
    end

    it "should check the presence of something"
  end
end