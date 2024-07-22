RSpec.describe TTY::Spinner::Multi, "#auto_spin" do
  let(:output) { StringIO.new("", "w+") }

  it "doesn't auto spin top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner", output: output)
    allow(spinners.top_spinner).to receive(:auto_spin)

    spinners.auto_spin

    expect(spinners.top_spinner).to_not have_received(:auto_spin)
  end

  it "raises an exception when called without a top spinner" do
    spinners = TTY::Spinner::Multi.new(output: output)

    expect {
      spinners.auto_spin
    }.to raise_error(RuntimeError, /No top level spinner/)
  end

  it "auto spins top level & child spinners with jobs" do
    spinners = TTY::Spinner::Multi.new("top", output: output)
    jobs = []

    spinners.register("one") { |sp| jobs << "one"; sp.success }
    spinners.register("two") { |sp| jobs << "two"; sp.success }

    spinners.auto_spin

    expect(jobs).to match_array(%w[one two])
    expect(spinners.top_spinner.done?).to be(true)
  end

  context "when manual_stop option is set" do
    it "keeps the top level spinner spinning" do
      spinners = TTY::Spinner::Multi.new("top", output: output, manual_stop: true)
      jobs = []

      spinners.register("one") { |sp| jobs << "one"; sp.success }
      spinners.register("two") { |sp| jobs << "two"; sp.success }

      spinners.auto_spin

      spinner = spinners.register("three") { |sp| jobs << "three"; sp.success }
      spinner.run

      expect(jobs).to match_array(%w[one two three])

      expect(spinners.top_spinner.done?).to be(false)
      spinners.success
      expect(spinners.top_spinner.done?).to be(true)
    end
  end
end
