# frozen_string_literal: true

require 'bundler/inline'


RSpec.configure do |config|
    config.before(:all, &:silence_output)
    config.after(:all,  &:enable_output)
  end
  
  public
  def silence_output
    $stdout = File.new(File::NULL, 'w')
  end
  
  def enable_output
    $stdout = STDOUT
  end

RSpec.describe Annotations do


    
  context 'Base usage' do
    it 'has a version number' do
      expect(Annotations::VERSION).not_to be nil
    end

    it "must be possible to add a simple annotation" do
        class A 
            using AnnotationRefinement
            annotate!

            §test 'string'
            def method
            end

        end

        expect(A.annotations).to eq({:method=>{:test=>"string"}})

    end
    

    it "must be possible to add a simple annotation and get annotation from instance" do
        class A 
            using AnnotationRefinement
            annotate!

            §test 'string'
            def method
                return annotations
            end

        end

        expect(A.new.method).to eq({:method=>{:test=>"string"}})

    end


    it "must be possible to add some annotions on different methods and get specific annotation from instance" do
        class A 
            using AnnotationRefinement
            annotate!

            §test 'string'
            def method
                return annotations(__callee__)
            end

            §test2 'string2'
            def method2
            end

        end

        expect(A.new.method).to eq({:test=>"string"})
        expect(A.annotations).to eq({:method=>{:test=>"string"}, :method2=>{:test2=>"string2"}})
    end
    

  end

  context 'Fields retrieving' do
    it 'must be possible to define string fields by annotation' do
        class A 
            using AnnotationRefinement
            annotate!
            §after ->{ puts 'test'}
            §test_string 'string'
            def method
              return fields(__callee__)
            end 
        end
        expect(A.new.method).to eq({:test_string=>"string"})

    end
  end

  context 'Hooks retrieving' do
    it 'must be possible to define string fields by annotation' do
        class A 
            using AnnotationRefinement
            annotate!
            §after ->{ puts 'test'}
            §test_string 'string'
            def method
              return hooks(__callee__)
            end 
        end
        expect(A.new.method.keys.first).to eq :after 
        expect(A.new.method.values.first).to be_an_instance_of Proc

    end
  end

  context 'Fields datas check' do

    it "must be possible to define String annotations" do
        class A 
            using AnnotationRefinement
            annotate!
            §test 'string'
            def method
                return annotations(__callee__)
            end
        end
        expect(A.new.method[:test]).to be_an_instance_of String
    end

    it "must be possible to define Numeric annotations" do
        class A 
            using AnnotationRefinement
            annotate!
            §test 12345
            def method
                return annotations(__callee__)
            end
        end
        expect(A.new.method[:test]).to be_an_instance_of Integer
    end

    it "must be possible to define List annotations" do
        class A 
            using AnnotationRefinement
            annotate!
            §test [12,"test", {test: "test"}]
            def method
                return annotations(__callee__)
            end
        end
        expect(A.new.method[:test]).to be_an_instance_of Array
    end

    it "must be possible to define Boolean annotations" do
        class A 
            using AnnotationRefinement
            annotate!
            §test 
            def method
                return annotations(__callee__)
            end
        end
        expect(A.new.method[:test]).to eq true
    end

    it "must be possible to define hybride splat list annotations" do
        class A 
            using AnnotationRefinement
            annotate!
            §test 10, {}, [], 'string' 
            def method
                return annotations(__callee__)
            end
        end
        expect(A.new.method[:test]).to eq [10, {}, [], 'string']
    end


  end

  context "Hooks executions" do
    it "must be possible toexecute before hook" do
        class A 
            using AnnotationRefinement
            annotate!
            §before -> { puts 'test'}
            def method
                puts 'in'
            end
        end
        enable_output
        expect { A.new.method }.to output("test\nin\n").to_stdout

    end
    
    it "must be possible toexecute before hook" do
        class A 
            using AnnotationRefinement
            annotate!
            §after -> { puts 'test'}
            def method
                puts 'in'
            end
        end
        enable_output
        expect { A.new.method }.to output("in\ntest\n").to_stdout

    end
  end


end



