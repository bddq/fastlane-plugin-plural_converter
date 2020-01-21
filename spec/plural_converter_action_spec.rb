describe Fastlane::Actions::PluralConverterAction do
  let(:action) { Fastlane::Actions::PluralConverterAction }
  let(:xml_path) { "assets/android.xml" }
  let(:plist_path) { "assets/Localizable.stringsdict" }

  it 'runs' do
    expect(Fastlane::UI).to receive(:success).with("Updated #{plist_path} 💾.")

    action.run(
      xml_path: xml_path,
      plist_path: plist_path
    )
  end

  context 'displays error' do
    it 'missing plist path' do
      expect(Fastlane::UI).to receive(:user_error!).with("You must specify a plist path")

      action.run(
        xml_path: "assets/android.xml"
      )
    end

    it 'missing xml path' do
      expect(Fastlane::UI).to receive(:user_error!).with("You must specify an xml path")

      action.run(
        plist_path: plist_path
      )
    end

    it 'xml file not found' do
      bad_xml_path = "assets/plural.xml"
      expect(Fastlane::UI).to receive(:user_error!).with("Couldn't find xml file at path '#{bad_xml_path}'")

      action.run(
        xml_path: bad_xml_path,
        plist_path: plist_path
      )
    end
  end

  context 'is supported' do
    it 'on iOS' do
      expect(action.is_supported?(:ios)).to be true
    end

    it 'on Android' do
      expect(action.is_supported?(:android)).to be true
    end
  end

  it 'has a description' do
    expect(action.description).to_not(be_nil)
  end

  it 'has details' do
    expect(action.description).to_not(be_nil)
  end

  it 'has authors' do
    expect(action.authors).to_not(be_nil)
  end

  it 'has options' do
    available_options = action.available_options
    expect(available_options.kind_of?(Array)).to be true
    expect(available_options.count).to be 2
  end
end
