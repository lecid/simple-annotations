# frozen_string_literal: true

require 'version'

module Annotations
  # the version of simple_annotations
  VERSION = Version.current

  RESERVED_ANNOTATIONS = %i[after before].freeze

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def annotations(meth = nil)
    annotation = AnnotationMonitor.registered[self.class.to_s.to_sym]
    return annotation[meth] if meth

    annotation
  end

  def hooks(meth = nil)
    if meth
      annotations(meth).slice(*RESERVED_ANNOTATIONS)
    else
      res = {}
      annotations.each_key do |val|
        res[val] = annotations[val].select do |item, _val|
          RESERVED_ANNOTATIONS.include? item
        end
      end
      res
    end
  end

  def fields(meth = nil)
    if meth
      annotations(meth).except(*RESERVED_ANNOTATIONS)
    else
      res = {}
      annotations.each_key do |val|
        res[val] = annotations[val].except(*RESERVED_ANNOTATIONS)
      end
      res
    end
  end

  module ClassMethods
    def annotations(meth = nil)
      return AnnotationMonitor.registered[self.class.to_s.to_sym][meth] if meth

      AnnotationMonitor.registered[to_s.to_sym]
    end

    private

    def method_added(m)
      AnnotationMonitor.registered[to_s.to_sym][m] = @last_annotations if @last_annotations
      @last_annotations = nil
      super
    end

    def method_missing(meth, *args)
      return super unless /\A§/ =~ meth

      @last_annotations ||= {}
      @last_annotations[meth[1..].to_sym] = if args.empty?
                                              true
                                            elsif args.size == 1
                                              args.first
                                            else
                                              args
                                            end
    end
  end
end

class AnnotationMonitor

  def AnnotationMonitor::register(aClass)
    @@annotated[aClass] = {}
  end

  def AnnotationMonitor::registered
    @@annotated
  end

  @@annotated = {}
  @@before = TracePoint.new(:call) do |tp|
    selected_class = tp.defined_class.to_s.to_sym
    called_method = tp.method_id
    if AnnotationMonitor.registered.include? selected_class
      annotations = AnnotationMonitor.registered[selected_class][called_method]
      annotations[:before].call if annotations.include? :before

    end
  end
  @@after = TracePoint.new(:return) do |tp|
    selected_class = tp.defined_class.to_s.to_sym
    called_method = tp.method_id
    if AnnotationMonitor.registered.include? selected_class
      annotations = AnnotationMonitor.registered[selected_class][called_method]
      annotations[:after].call if annotations.include? :after

    end
  end
  @@after.enable unless @@after.enabled?
  @@before.enable unless @@before.enabled?

 
end

module AnnotationRefinement
  refine Module do
    private

    def annotate!
      AnnotationMonitor.register(to_s.to_sym)
      include Annotations
    end
  end
end
