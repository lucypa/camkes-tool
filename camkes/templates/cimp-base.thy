/*#
 *# Copyright 2015, NICTA
 *#
 *# This software may be distributed and modified according to the terms of
 *# the BSD 2-Clause license. Note that NO WARRANTY is provided.
 *# See "LICENSE_BSD2.txt" for details.
 *#
 *# @TAG(NICTA_BSD)
 #*/

/*# Ignore the following line. It is intended to apply to the output of this
 *# template.
#*/
(* THIS FILE IS AUTOMATICALLY GENERATED. YOUR EDITS WILL BE OVERWRITTEN. *)
theory /*? os.path.splitext(os.path.basename(options.outfile.name))[0] ?*/ imports
  "~~/../l4v/camkes/glue-spec/Types"
  "~~/../l4v/camkes/glue-spec/Abbreviations"
  "~~/../l4v/camkes/glue-spec/Connector"
begin

/*- macro show_native_type(type) -*/
    /*- if type in ['int', 'int8_t', 'int16_t', 'int32_t', 'int64_t'] -*/
        int
    /*- elif type in ['unsigned int', 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t', 'uintptr_t'] -*/
        nat
    /*- elif type in ['char', 'character'] -*/
        char
    /*- elif type == 'bool' -*/
        bool
    /*- elif type == 'string' -*/
        string
    /*- else -*/
        /*? raise(TemplateError('unsupported')) ?*/
    /*- endif -*/
/*- endmacro -*/

/*- macro show_wrapped_type(type) -*/
    /*- if type in ['int', 'int8_t', 'int16_t', 'int32_t', 'int64_t'] -*/
        Integer
    /*- elif type in ['unsigned int', 'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t', 'uintptr_t'] -*/
        Number
    /*- elif type in ['char', 'character'] -*/
        Char
    /*- elif type == 'bool' -*/
        Boolean
    /*- elif type == 'string' -*/
        String
    /*- else -*/
        /*? raise(TemplateError('unsupported')) ?*/
    /*- endif -*/
/*- endmacro -*/

/*- set instances = composition.instances -*/
/*- set connections = composition.connections -*/
/*- set components = reduce(lambda('xs, b: xs + ([b.type] if b.type not in xs else [])'), instances, []) -*/

(* Connections *)
datatype channel =
/*- set j = joiner('|') -*/
/*- for c in connections -*/
    /*? j() ?*/ /*? c.name ?*/
/*- endfor -*/

(* Component instances *)
datatype inst =
/*- set j = joiner('|') -*/
/*- for i in instances -*/
    /*? j() ?*/ /*? i.name ?*/
/*- endfor -*/
/*- for c in connections -*/
  /*- if c.type.from_type == 'Event' -*/
  | /*? c.name ?*/\<^sub>e
  /*- elif c.type.from_type == 'Dataport' -*/
  | /*? c.name ?*/\<^sub>d
  /*- endif -*/
/*- endfor -*/

/*- for c in components -*/

    (* /*? c.name ?*/'s interfaces *)
    datatype /*? c.name ?*/_channel =
    /*- set j = joiner('|') -*/
    /*- for i in c.uses + c.provides + c.emits + c.consumes + c.dataports -*/
        /*? j() ?*/ /*? c.name ?*/_/*? i.name ?*/
    /*- endfor -*/

    /*# Glue code for each outgoing procedural interface. #*/
    /*- for u in c.uses -*/
        /*- for i, m in enumerate(u.type.methods) -*/
            definition
                Call_/*? c.name ?*/_/*? u.name ?*/_/*? m.name ?*/ :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow>
                /*- for p in filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters) -*/
                    ('cs local_state \<Rightarrow> /*? show_native_type(p.type) ?*/) \<Rightarrow>
                /*- endfor -*/
                /*- if m.return_type is not none or len(list(filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters))) > 0 -*/
                    ('cs local_state
                /*- endif -*/
                /*- if m.return_type is not none -*/
                    \<Rightarrow> /*? show_native_type(m.return_type) ?*/
                /*- endif -*/
                /*- for p in filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters) -*/
                    \<Rightarrow> /*? show_native_type(p.type) ?*/
                /*- endfor -*/
                /*- if m.return_type is not none or len(list(filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters))) > 0 -*/
                    /*# We had to unmarshal at least one parameter. #*/
                    \<Rightarrow> 'cs local_state) \<Rightarrow>
                /*- endif -*/
                (channel, 'cs) comp"
            where
                /*- set ch = isabelle_symbol('ch') -*/
                "Call_/*? c.name ?*/_/*? u.name ?*/_/*? m.name ?*/ /*? ch ?*/
                /*- for p in filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters) -*/
                    /*? p.name ?*/\<^sub>P
                /*- endfor -*/
                /*- if m.return_type is not none or len(list(filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters))) > 0 -*/
                    embed
                /*- endif -*/
                /*- set s = isabelle_symbol('s') -*/
                \<equiv> Request (\<lambda>/*? s ?*/. {\<lparr>q_channel = /*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/, q_data = Call /*? i ?*/ (
                /*- for p in filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters) -*/
                    /*? show_wrapped_type(p.type) ?*/ (/*? p.name ?*/\<^sub>P /*? s ?*/) #
                /*- endfor -*/
                [])\<rparr>}) discard ;;
                /*- set q = isabelle_symbol() -*/
                /*- set s = isabelle_symbol() -*/
                /*- set xs = isabelle_symbol() -*/
                Response (\<lambda>/*? q ?*/ /*? s ?*/. case q_data /*? q ?*/ of Return /*? xs ?*/ \<Rightarrow>
                /*- if m.return_type is not none or len(list(filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters))) > 0 -*/
                    {(embed /*? s ?*/
                    /*- if m.return_type is not none -*/
                        /*- set v = isabelle_symbol() -*/
                        (case hd /*? xs ?*/ of /*? show_wrapped_type(m.return_type) ?*/ /*? v ?*/ \<Rightarrow> /*? v ?*/)
                    /*- endif -*/
                    /*- for i, p in enumerate(filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters)) -*/
                        /*- set v = isabelle_symbol() -*/
                        (case /*? xs ?*/ ! /*? i + (1 if m.return_type is not none else 0) ?*/ of /*? show_wrapped_type(p.type) ?*/ /*? v ?*/ \<Rightarrow> /*? v ?*/)
                    /*- endfor -*/
                /*- else -*/
                    {(/*? s ?*/
                /*- endif -*/
                , \<lparr>a_channel = /*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/, a_data = Void\<rparr>)} | _ \<Rightarrow> {})"
        /*- endfor -*/
    /*- endfor -*/

    /*# Glue code for each incoming procedural interface. #*/
    /*- for u in c.provides -*/
        definition
            Recv_/*? c.name ?*/_/*? u.name ?*/ :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow>
            /*- for m in u.type.methods -*/
                /*- if len(list(filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters))) > 0 -*/
                    ('cs local_state \<Rightarrow>
                    /*- for p in filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters) -*/
                        /*? show_native_type(p.type) ?*/ \<Rightarrow>
                    /*- endfor -*/
                    'cs local_state) \<Rightarrow>
                /*- endif -*/
                (channel, 'cs) comp \<Rightarrow>
                /*- if m.return_type is not none -*/
                    ('cs local_state \<Rightarrow> /*? show_native_type(m.return_type) ?*/) \<Rightarrow>
                /*- endif -*/
                /*- for p in filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters) -*/
                    ('cs local_state \<Rightarrow> /*? show_native_type(p.type) ?*/) \<Rightarrow>
                /*- endfor -*/
            /*- endfor -*/
            (channel, 'cs) comp"
        where
            /*- set ch = isabelle_symbol('ch') -*/
            "Recv_/*? c.name ?*/_/*? u.name ?*/ /*? ch ?*/
            /*- for m in u.type.methods -*/
                /*- if len(list(filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters))) > 0 -*/
                    /*? m.name ?*/\<^sub>E
                /*- endif -*/
                /*? c.name ?*/_/*? u.name ?*/_/*? m.name ?*/
                /*- if m.return_type is not none -*/
                    /*? m.name ?*/_return\<^sub>P
                /*- endif -*/
                /*- for p in filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters) -*/
                    /*? m.name ?*/_/*? p.name ?*/\<^sub>P
                /*- endfor -*/
            /*- endfor -*/
            \<equiv>
            /*- for i, m in enumerate(u.type.methods) -*/
                /*- if not loop.first -*/
                    \<squnion>
                /*- endif -*/
                /*- set q = isabelle_symbol() -*/
                /*- set s = isabelle_symbol() -*/
                /*- set n = isabelle_symbol() -*/
                /*- set xs = isabelle_symbol() -*/
                (Response (\<lambda>/*? q ?*/ /*? s ?*/. case q_data /*? q ?*/ of Call /*? n ?*/ /*? xs ?*/ \<Rightarrow> (if /*? n ?*/ = /*? i ?*/ then {(
                /*- if len(list(filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters))) > 0 -*/
                    /*? m.name ?*/\<^sub>E /*? s ?*/
                    /*- for k, p in enumerate(filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters)) -*/
                        /*- set v = isabelle_symbol() -*/
                        (case /*? xs ?*/ ! /*? k ?*/ of /*? show_wrapped_type(p.type) ?*/ /*? v ?*/ \<Rightarrow> /*? v ?*/)
                    /*- endfor -*/
                /*- else -*/
                    /*? s ?*/
                /*- endif -*/
                , \<lparr>a_channel = /*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/, a_data = Void\<rparr>)} else {}) | _ \<Rightarrow> {}) ;;
                /*? c.name ?*/_/*? u.name ?*/_/*? m.name ?*/ ;;
                /*- set s = isabelle_symbol() -*/
                Request (\<lambda>/*? s ?*/. {\<lparr>q_channel = /*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/, q_data = Return (
                /*- if m.return_type is not none -*/
                    /*? show_wrapped_type(m.return_type) ?*/ (/*? m.name ?*/_return\<^sub>P /*? s ?*/) #
                /*- endif -*/
                /*- for p in filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters) -*/
                    /*? show_wrapped_type(p.type) ?*/ (/*? m.name ?*/_/*? p.name ?*/\<^sub>P /*? s ?*/) #
                /*- endfor -*/
                [])\<rparr>}) discard)
            /*- endfor -*/
            "
    /*- endfor -*/

    /*# Glue code for each outgoing event interface. #*/
    /*- for u in c.emits -*/
        definition
            Emit_/*? c.name ?*/_/*? u.name ?*/ :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set ch = isabelle_symbol('ch') -*/
            "Emit_/*? c.name ?*/_/*? u.name ?*/ /*? ch ?*/ \<equiv> EventEmit (/*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/)"
    /*- endfor -*/

    /*# Glue code for each incoming event interface. #*/
    /*- for u in c.consumes -*/
        definition
            Poll_/*? c.name ?*/_/*? u.name ?*/ :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow> ('cs local_state \<Rightarrow> bool \<Rightarrow> 'cs local_state) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set ch = isabelle_symbol('ch') -*/
            /*- set embed = isabelle_symbol('embed') -*/
            "Poll_/*? c.name ?*/_/*? u.name ?*/ /*? ch ?*/ /*? embed ?*/ \<equiv> EventPoll (/*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/) /*? embed ?*/"

        definition
            Wait_/*? c.name ?*/_/*? u.name ?*/ :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow> ('cs local_state \<Rightarrow> bool \<Rightarrow> 'cs local_state) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set embed = isabelle_symbol('embed') -*/
            "Wait_/*? c.name ?*/_/*? u.name ?*/ /*? ch ?*/ /*? embed ?*/ \<equiv> EventWait (/*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/) /*? embed ?*/"
    /*- endfor -*/

    /*# Glue code for dataport interfaces. #*/
    /*- for u in c.dataports -*/
        definition
            Read_/*? c.name ?*/_/*? u.name ?*/ :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow> ('cs local_state \<Rightarrow> nat) \<Rightarrow> ('cs local_state \<Rightarrow> variable \<Rightarrow> 'cs local_state) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set ch = isabelle_symbol('ch') -*/
            /*- set addr = isabelle_symbol('addr') -*/
            /*- set embed = isabelle_symbol('embed') -*/
            "Read_/*? c.name ?*/_/*? u.name ?*/ /*? ch ?*/ /*? addr ?*/ /*? embed ?*/ \<equiv> MemoryRead (/*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/) /*? addr ?*/ /*? embed ?*/"

        definition
            Write_/*? c.name ?*/_/*? u.name ?*/ :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow> ('cs local_state \<Rightarrow> nat) \<Rightarrow> ('cs local_state \<Rightarrow> variable) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set ch = isabelle_symbol('ch') -*/
            /*- set addr = isabelle_symbol('addr') -*/
            /*- set proj = isabelle_symbol('proj') -*/
            "Write_/*? c.name ?*/_/*? u.name ?*/ /*? ch ?*/ /*? addr ?*/ /*? proj ?*/ \<equiv> MemoryWrite (/*? ch ?*/ /*? c.name ?*/_/*? u.name ?*/) /*? addr ?*/ /*? proj ?*/"
    /*- endfor -*/

/*- endfor -*/

(* Component instantiations *)
/*- for i in instances -*/
    /*- set c = i.type -*/

    /*- for u in c.uses -*/
        /*- for m in u.type.methods -*/
            definition
                Call_/*? i.name ?*/_/*? u.name ?*/_/*? m.name ?*/ :: "
                /*- for p in filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters) -*/
                    ('cs local_state \<Rightarrow> /*? show_native_type(p.type) ?*/) \<Rightarrow>
                /*- endfor -*/
                /*- if m.return_type is not none or len(list(filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters))) > 0 -*/
                    ('cs local_state \<Rightarrow>
                /*- endif -*/
                /*- if m.return_type is not none -*/
                    \<Rightarrow> /*? show_native_type(m.return_type) ?*/
                /*- endif -*/
                /*- for p in filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters) -*/
                    \<Rightarrow> /*? show_native_type(p.type) ?*/
                /*- endfor -*/
                /*- if m.return_type is not none or len(list(filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters))) > 0 -*/
                    /*# We had to unmarshal at least one parameter. #*/
                    \<Rightarrow> 'cs local_state) \<Rightarrow>
                /*- endif -*/
                (channel, 'cs) comp"
            where
                "Call_/*? i.name ?*/_/*? u.name ?*/_/*? m.name ?*/ \<equiv>
                    /*- set l = isabelle_symbol() -*/
                    Call_/*? c.name ?*/_/*? u.name ?*/_/*? m.name ?*/ (\<lambda>/*? l ?*/. case /*? l ?*/ of
                    /*- set j = joiner('|') -*/
                    /*- for conn in connections -*/
                        /*- if len(conn.from_ends) != 1 -*/
                            /*? raise(TemplateError('connections without a single from end are not supported', conn)) ?*/
                        /*- endif -*/
                        /*- if len(conn.to_ends) != 1 -*/
                            /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
                        /*- endif -*/
                        /*- if conn.from_instance.name == i.name -*/
                            /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                        /*- endif -*/
                        /*- if conn.to_instance.name == i.name -*/
                            /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                        /*- endif -*/
                    /*- endfor -*/
                    )"
        /*- endfor -*/
    /*- endfor -*/

    /*- for u in c.provides -*/
        definition
            Recv_/*? i.name ?*/_/*? u.name ?*/ :: "
            /*- for m in u.type.methods -*/
                /*- if len(list(filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters))) > 0 -*/
                    ('cs local_state \<Rightarrow>
                    /*- for p in filter(lambda('x: x.direction in [\'in\', \'inout\']'), m.parameters) -*/
                        /*? show_native_type(p.type) ?*/ \<Rightarrow>
                    /*- endfor -*/
                    'cs local_state) \<Rightarrow>
                /*- endif -*/
                (channel, 'cs) comp \<Rightarrow>
                /*- if m.return_type -*/
                    ('cs local_state \<Rightarrow> /*? show_native_type(m.return_type) ?*/) \<Rightarrow>
                /*- endif -*/
                /*- for p in filter(lambda('x: x.direction in [\'out\', \'inout\']'), m.parameters) -*/
                    ('cs local_state \<Rightarrow> /*? show_native_type(p.type) ?*/) \<Rightarrow>
                /*- endfor -*/
            /*- endfor -*/
            (channel, 'cs) comp"
        where
            "Recv_/*? i.name ?*/_/*? u.name ?*/ \<equiv>
                /*- set l = isabelle_symbol() -*/
                Recv_/*? c.name ?*/_/*? u.name ?*/ (\<lambda>/*? l ?*/. case /*? l ?*/ of
                /*- set j = joiner('|') -*/
                /*- for conn in connections -*/
                    /*- if len(conn.to_ends) != 1 -*/
                        /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
                    /*- endif -*/
                    /*- if conn.from_instance.name == i.name -*/
                        /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                    /*- endif -*/
                    /*- if conn.from_instance.name == i.name -*/
                        /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                    /*- endif -*/
                    /*- if conn.to_instance.name == i.name -*/
                        /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                    /*- endif -*/
                /*- endfor -*/
                )"
    /*- endfor -*/

    /*- for u in c.emits -*/
        definition
            Emit_/*? i.name ?*/_/*? u.name ?*/ :: "(channel, 'cs) comp"
        where
            /*- set l = isabelle_symbol() -*/
            "Emit_/*? i.name ?*/_/*? u.name ?*/ \<equiv> Emit_/*? c.name ?*/_/*? u.name ?*/ (\<lambda>/*? l ?*/. case /*? l ?*/ of
            /*- set j = joiner('|') -*/
            /*- for conn in connections -*/
                /*- if len(conn.to_ends) != 1 -*/
                    /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.to_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
            /*- endfor -*/
            )"
    /*- endfor -*/

    /*- for u in c.consumes -*/
        definition
            Poll_/*? i.name ?*/_/*? u.name ?*/ :: "('cs local_state \<Rightarrow> bool \<Rightarrow> 'cs local_state) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set l = isabelle_symbol() -*/
            "Poll_/*? i.name ?*/_/*? u.name ?*/ \<equiv> Poll_/*? c.name ?*/_/*? u.name ?*/ (\<lambda>/*? l ?*/. case /*? l ?*/ of
            /*- set j = joiner('|') -*/
            /*- for conn in connections -*/
                /*- if len(conn.to_ends) != 1 -*/
                    /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.to_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
            /*- endfor -*/
            )"

        definition
            Wait_/*? i.name ?*/_/*? u.name ?*/ :: "('cs local_state \<Rightarrow> bool \<Rightarrow> 'cs local_state) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set l = isabelle_symbol() -*/
            "Wait_/*? i.name ?*/_/*? u.name ?*/ \<equiv> Wait_/*? c.name ?*/_/*? u.name ?*/ (\<lambda>/*? l ?*/. case /*? l ?*/ of
            /*- set j = joiner('|') -*/
            /*- for conn in connections -*/
                /*- if len(conn.to_ends) != 1 -*/
                    /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.to_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
            /*- endfor -*/
            )"
    /*- endfor -*/

    /*- for u in c.dataports -*/
        definition
            Read_/*? i.name ?*/_/*? u.name ?*/ :: "('cs local_state \<Rightarrow> nat) \<Rightarrow> ('cs local_state \<Rightarrow> variable \<Rightarrow> 'cs local_state) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set l = isabelle_symbol() -*/
            "Read_/*? i.name ?*/_/*? u.name ?*/ \<equiv> Read_/*? c.name ?*/_/*? u.name ?*/ (\<lambda>/*? l ?*/. case /*? l ?*/ of
            /*- set j = joiner('|') -*/
            /*- for conn in connections -*/
                /*- if len(conn.to_ends) != 1 -*/
                    /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.to_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
            /*- endfor -*/
            )"

        definition
            Write_/*? i.name ?*/_/*? u.name ?*/ :: "('cs local_state \<Rightarrow> nat) \<Rightarrow> ('cs local_state \<Rightarrow> variable) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set l = isabelle_symbol() -*/
            "Write_/*? i.name ?*/_/*? u.name ?*/ \<equiv> Write_/*? c.name ?*/_/*? u.name ?*/ (\<lambda>/*? l ?*/. case /*? l ?*/ of
            /*- set j = joiner('|') -*/
            /*- for conn in connections -*/
                /*- if len(conn.to_ends) != 1 -*/
                    /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.from_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
                /*- if conn.to_instance.name == i.name -*/
                    /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
                /*- endif -*/
            /*- endfor -*/
            )"
    /*- endfor -*/

/*- endfor -*/

locale system_state =
    fixes init_component_state :: 'cs
    fixes trusted :: "(inst, ((channel, 'cs) comp \<times> 'cs local_state)) map"
begin

/*- for c in components -*/
    /*# Emit a broad definition for each component if the user does not want to instantiate it. #*/
    definition
        /*? c.name ?*/_untrusted :: "(/*? c.name ?*/_channel \<Rightarrow> channel) \<Rightarrow> (channel, 'cs) comp"
    where
        /*- set ch = isabelle_symbol('ch') -*/
        "/*? c.name ?*/_untrusted /*? ch ?*/ \<equiv>
            LOOP (
                UserStep
                /*- for i in c.uses + c.provides + c.emits + c.consumes + c.dataports -*/
                    \<squnion> ArbitraryRequest (/*? ch ?*/ /*? c.name ?*/_/*? i.name ?*/)
                    \<squnion> ArbitraryResponse (/*? ch ?*/ /*? c.name ?*/_/*? i.name ?*/)
                /*- endfor -*/
            )"
/*- endfor -*/

/*# Emit simulated components for each event. #*/
/*- for e in reduce(lambda('xs, b: xs + ([b.type] if b.type not in xs else [])'), flatMap(lambda('x: x.emits + x.consumes'), components), []) -*/
    (* Simulated component for event /*? e ?*/. *)
    type_synonym /*? e ?*/_channel = unit

    definition
        /*? e ?*/ :: "(/*? e ?*/_channel \<Rightarrow> channel) \<Rightarrow> (channel, 'cs) comp"
    where
        /*- set ch = isabelle_symbol('ch') -*/
        "/*? e ?*/ /*? ch ?*/ \<equiv> event (/*? ch ?*/ ())"
/*- endfor -*/

/*# Emit simulated components for each dataport. #*/
/*- for d in reduce(lambda('xs, b: xs + ([b.type] if b.type not in xs else [])'), flatMap(lambda('x: x.dataports'), components), []) -*/
    /*# The built-in type 'Buf' is defined in Connector.thy. #*/
    /*- if d != 'Buf' -*/
        type_synonym /*? d ?*/\<^sub>d_channel = unit

        definition
            /*? d ?*/\<^sub>d :: "(/*? d ?*/\<^sub>d_channel \<Rightarrow> channel) \<Rightarrow> (channel, 'cs) comp"
        where
            /*- set ch = isabelle_symbol('ch') -*/
            "/*? d ?*/\<^sub>d /*? ch ?*/ \<equiv> memory (/*? ch ?*/ ())"
    /*- endif -*/
/*- endfor -*/

(* Component instantiations *)
/*- for i in instances -*/
    /*- set c = i.type -*/

    definition
        /*? i.name ?*/_untrusted :: "(channel, 'cs) comp"
    where
        /*- set l = isabelle_symbol() -*/
        "/*? i.name ?*/_untrusted \<equiv> /*? c.name ?*/_untrusted (\<lambda>/*? l ?*/. case /*? l ?*/ of
        /*- set j = joiner('|') -*/
        /*- for conn in connections -*/
            /*- if len(conn.to_ends) != 1 -*/
                /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
            /*- endif -*/
            /*- if conn.from_instance.name == i.name -*/
                /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
            /*- endif -*/
            /*- if conn.from_instance.name == i.name -*/
                /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
            /*- endif -*/
            /*- if conn.to_instance.name == i.name -*/
                /*? j() ?*/ /*? c.name ?*/_/*? conn.to_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
            /*- endif -*/
        /*- endfor -*/
        )"

/*- endfor -*/

/*# Simulated component instance for each event connection. #*/
/*- for c in filter(lambda('x: x.type.from_type == \'Event\''), connections) -*/
    definition
        /*? c.name ?*/\<^sub>e_instance :: "(channel, 'cs) comp"
    where
        "/*? c.name ?*/\<^sub>e_instance \<equiv> /*? c.from_interface.type ?*/ (\<lambda>_. /*? c.name ?*/)"
/*- endfor -*/

/*# Simulated component instance for each dataport connection. #*/
/*- for c in filter(lambda('x: x.type.from_type == \'Dataport\''), connections) -*/
    definition
        /*? c.name ?*/\<^sub>d_instance :: "(channel, 'cs) comp"
    where
        "/*? c.name ?*/\<^sub>d_instance \<equiv> /*? c.from_interface.type ?*/\<^sub>d (\<lambda>_. /*? c.name ?*/)"
/*- endfor -*/

(* Global initial state *)
/*# Even though this is generated as a mapping to an option type it is actually
 ** full.
 #*/
definition
    gs\<^sub>0 :: "(inst, channel, 'cs) global_state"
where
    /*- set p = isabelle_symbol('p') -*/
    /*- set s = isabelle_symbol() -*/
    "gs\<^sub>0 /*? p ?*/ \<equiv> case trusted /*? p ?*/ of Some /*? s ?*/ \<Rightarrow> Some /*? s ?*/ | _ \<Rightarrow> (case /*? p ?*/ of
    /*- set j = joiner('|') -*/
    /*- for i in instances -*/
        /*? j() ?*/ /*? i.name ?*/ \<Rightarrow> Some (/*? i.name ?*/_untrusted, Component init_component_state)
    /*- endfor -*/
    /*- for c in connections -*/
        /*- if len(conn.to_ends) != 1 -*/
            /*? raise(TemplateError('connections without a single to end are not supported', conn)) ?*/
        /*- endif -*/
        /*- if conn.from_instance.name == i.name -*/
            /*? j() ?*/ /*? c.name ?*/_/*? conn.from_interface.name ?*/ \<Rightarrow> /*? conn.name ?*/
        /*- endif -*/
        /*- if c.type.from_type == 'Event' -*/
            /*? j() ?*/ /*? c.name ?*/\<^sub>e \<Rightarrow> Some (/*? c.name ?*/\<^sub>e_instance, init_event_state)
        /*- elif c.type.from_type == 'Dataport' -*/
            /*? j() ?*/ /*? c.name ?*/\<^sub>d \<Rightarrow> Some (/*? c.name ?*/\<^sub>d_instance, init_memory_state)
        /*- endif -*/
    /*- endfor -*/
    )"

end

end
