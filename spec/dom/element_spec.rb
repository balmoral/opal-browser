require 'spec_helper'

describe Browser::DOM::Element do
  describe '#id' do
    html <<-HTML
      <div id="lol"><div class="wut"></div></div>
    HTML

    it 'gets the proper id' do
      expect($document["lol"].id).to eq('lol')
    end

    it 'returns nil when there is no id' do
      expect($document["#lol .wut"].id).to be_nil
    end
  end

  describe '#id=' do
    html <<-HTML
      <div id="lol"></div>
    HTML

    it 'sets the id' do
      el = $document["lol"]
      el.id = 'wut'

      expect(el.id).to eq('wut')
    end

    it 'removes the id when the value is nil' do
      el = $document["lol"]
      el.id = nil

      expect(el.id).to be_nil
    end
  end

  describe '#class_names' do
    html <<-HTML
      <div id="class-names">
        <div id="class-names-1" class="a b c"></div>
        <div id="class-names-2" class=""></div>
      </div>
    HTML

    it 'gives an empty array when no class is set' do
      expect($document["class-names-2"].class_names).to eq([])
    end

    it 'gives an array of class names' do
      expect($document["class-names-1"].class_names).to eq(%w[a b c])
    end
  end

  describe '#=~' do
    html <<-HTML
      <div id="matches" class="not me">
        <span class="yes me"></span>
      </div>
    HTML

    it 'matches on class and id' do
      expect($document[:matches] =~ '#matches.not.me').to be_truthy
    end

    it 'matches on class and name' do
      expect($document[:matches].first_element_child =~ 'span.yes').to be_truthy
    end
  end

  describe '#inspect' do
    it 'uses the node name' do
      el = $document.create_element('div')

      expect(el.inspect).to match(/: div>/)
    end

    it 'uses the id' do
      el = $document.create_element('div')
      el.id = 'lol'

      expect(el.inspect).to match(/: div.lol!>/)
    end

    it 'uses the classes' do
      el = $document.create_element('div')
      el.add_class 'lol', 'wut'

      expect(el.inspect).to match(/: div.lol.wut>/)
    end

    it 'uses the id and the classes' do
      el = $document.create_element('div')
      el.id = 'omg'
      el.add_class 'lol', 'wut'

      expect(el.inspect).to match(/: div.omg!.lol.wut>/)
    end
  end
end
