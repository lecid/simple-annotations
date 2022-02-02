module Annotations
  


    RESERVED_ANNOTATIONS = [:after, :before]
  
    def self.included(klass)
      klass.extend(ClassMethods)
    end
  
    def annotations(meth=nil)
  
      annotation = AnnotationMonitor::registered[self.class.to_s.to_sym]
      return annotation[meth] if meth
      annotation
    end
  
  
    def hooks(meth=nil) 
      if meth then
        return annotations(meth).select {|item,val| RESERVED_ANNOTATIONS.include? item }
      else
        res = Hash::new
        annotations.keys.each {|val| res[val] = annotations[val].select{|item,val| RESERVED_ANNOTATIONS.include? item }}
        return res
      end
    end
  
    def fields(meth=nil)
      if meth then
        return annotations(meth).select {|item,val| RESERVED_ANNOTATIONS.include? item }
      else
        res = Hash::new
        annotations.keys.each {|val| res[val] = annotations[val].select{|item,val| not RESERVED_ANNOTATIONS.include? item }}
        return res
      end
    end
  
  
    module ClassMethods
      def annotations(meth=nil)
   
        return AnnotationMonitor::registered[self.class.to_s.to_sym][meth] if meth
        AnnotationMonitor::registered[self.to_s.to_sym]
      end
      
      private
      
      def method_added(m)
        AnnotationMonitor::registered[self.to_s.to_sym][m] = @last_annotations if @last_annotations
        @last_annotations = nil
        super
      end
      
      def method_missing(meth, *args)
        return super unless /\A§/ =~ meth
        @last_annotations ||= {}
        if args.size == 0
          @last_annotations[meth[1..-1].to_sym] = true 
        elsif args.size == 1
          @last_annotations[meth[1..-1].to_sym] = args.first
        else
          @last_annotations[meth[1..-1].to_sym] = args
        end
      end
      
    end
  end
  
  
  class AnnotationMonitor
    @@annotated ={}
    @@before = TracePoint.new(:call) do |tp|
        
      selected_class = tp.defined_class.to_s.to_sym
      called_method = tp.method_id
      if AnnotationMonitor::registered.include? selected_class then
        annotations = AnnotationMonitor::registered[selected_class][called_method]
        if annotations.include? :before then
          annotations[:before].call
        end
  
      end
     
    end
    @@after = TracePoint.new(:return) do |tp|
        
      selected_class = tp.defined_class.to_s.to_sym
      called_method = tp.method_id
      if AnnotationMonitor::registered.include? selected_class then
        annotations = AnnotationMonitor::registered[selected_class][called_method]
        if annotations.include? :after then
          annotations[:after].call
        end
  
      end
     
    end
    @@after.enable unless @@after.enabled?
    @@before.enable unless @@before.enabled?
  
    def AnnotationMonitor::register(aClass)
      @@annotated[aClass] = {}
    end 
  
    def AnnotationMonitor::registered
      return @@annotated
    end
  
  end
  
  class Module
  private
  
    def annotate!
      AnnotationMonitor::register(self.to_s.to_sym)
      include Annotations
    end
  end
  
  
  
  class A
      annotate!
      
      §toto "string"
      §after ->{ puts 'after'} 
      §before ->{ puts 'before'}
      def m1 
        p 'deb'
        puts 'toutes les annotations'
        p annotations
        puts 'annoation de cette fonction'
        p annotations(__callee__)
        puts 'les hooks'
        pp hooks
        puts 'les champs'
        pp fields
        p 'fin'
      end
      
      §toto 12
      §titi
      def m2; 
      end
    
      §foobar  color: 'cyan'
      def m3; end
  
      def m4; end
  
      §after ->{ puts 'm5 after'}
      def m5; end
  
      §test 10, {}, [], "string"
      def m6; end
  
    end
  
    puts 'annotations class'
    p A.annotations
  
  anA = A.new
  
  
    anA.m1
  