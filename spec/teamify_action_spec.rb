describe Fastlane::Actions::TeamifyAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The teamify plugin is working!")

      Fastlane::Actions::TeamifyAction.run(nil)
    end
  end
end
