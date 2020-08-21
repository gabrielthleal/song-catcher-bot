require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to(validate_uniqueness_of(:telegram_id)) }

  describe '#next_bot_command - set' do
    context 'when the command bot is right setted' do
      it { expect { user.next_bot_command = 'GoToTheNextMethod' }.to change { user.next_bot_command }.from(nil).to('GoToTheNextMethod') }
    end
  end

  describe '#next_bot_command - get' do
    context 'when get the right setted command bot' do
      it do
        user.next_bot_command = 'GoToTheNextMethod'

        expect(user.next_bot_command).to eq('GoToTheNextMethod')
      end
    end
  end

  describe '#reset_next_bot_command' do
    context 'when reset the command bot' do
      it do
        user.next_bot_command = 'GoToTheNextMethod'

        expect { user.reset_next_bot_command }.to change { user.next_bot_command }.from('GoToTheNextMethod').to(nil)
      end
    end
  end
end
