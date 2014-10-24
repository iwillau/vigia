require 'spec_helper'

describe Vigia::Blueprint do

  subject do
    described_class.new Vigia::ExampleTest.apib_source
  end

  before do
    allow(RedSnow).to receive(:parse).and_return(Vigia::ExampleTest.apib)
  end

  describe '#initialize' do
    it 'calls RedSnow::parse' do
      subject
      expect(RedSnow).to have_received(:parse).with(Vigia::ExampleTest.apib_source)
    end

    it 'has a #metadata getter' do
      expect(subject.metadata).to eql(Vigia::ExampleTest.apib.ast.metadata)
    end

    it 'has a #apib getter' do
      expect(subject.apib).to eql(Vigia::ExampleTest.apib.ast)
    end
  end

  describe '#inspector' do
    let(:inspector) { subject.inspector(object) }

    context 'when inspecting the Api Blueprint' do
      let(:object) { subject.apib }

      it 'returns the right data for a resource group' do
        expect(inspector).to eql(line: 0)
      end
    end

    context 'when inspecting a Resource Group' do
      let(:object) { subject.apib.resource_groups.first }

      it 'returns the right data for a resource group' do
        expect(inspector).to eql(line: 7)
      end
    end

    context 'when inspecting a the last resource group' do
      let(:object) { subject.apib.resource_groups.last }

      it 'returns the right data for a resource group' do
        expect(inspector).to eql(line: 161)
      end
    end

    context 'when inspecting a the first resource' do
      let(:object) { subject.apib.resource_groups.first.resources.first }

      it 'returns the right data for a resource' do
        expect(inspector).to eql(line: 9)
      end
    end

    context 'when inspecting a the last resource ' do
      let(:object) { subject.apib.resource_groups.last.resources.last }

      it 'returns the right data for a resource' do
        expect(inspector).to eql(line: 233)
      end
    end

    context 'when inspecting a the first action' do
      let(:object) { subject.apib.resource_groups.first.resources.first.actions.first }

      it 'returns the right data for the action' do
        expect(inspector).to eql(line: 12)
      end
    end

    context 'when inspecting a the last action ' do
      let(:object) { subject.apib.resource_groups.last.resources.last.actions.last }

      it 'returns the right data for the action' do
        expect(inspector).to eql(line: 270)
      end
    end

    context 'when inspecting a not valid object' do
      let(:object) { Array.new }

      it 'returns the right data for an unknown object ' do
        expect(inspector).to eql(line: 'undefined')
      end
    end
  end
end
