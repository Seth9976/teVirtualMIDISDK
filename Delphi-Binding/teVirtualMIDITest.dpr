{*  teVirtualMIDI Delphi interface
 *
 * Copyright 2009-2019, Tobias Erichsen
 * All rights reserved, unauthorized usage & distribution is prohibited.
 *
 *
 * File: teVirtualMIDITest.dpr
 *
 * This file contains a sample using the teVirtualMIDI-DLL-interface, which
 * implements a simple loopback-MIDI-port.
 *}

program teVirtualMIDITest;

{$APPTYPE CONSOLE}

uses
  windows,
  teVirtualMIDIdll,
  uStuff;


var dummy: word;
    port: LPVM_MIDI_PORT;



procedure teVMCallback( MidiPort: LPVM_MIDI_PORT; MidiDataBytes: PBYTE; DataLength: DWORD; dwCallbackInstance: Pointer ); stdcall;
begin
  if ( mididatabytes = nil ) or ( datalength = 0 ) then
    begin
      writeln('empty command - driver was probably shut down!');
      exit;
    end;
  if not virtualMIDISendData( midiport, mididatabytes, datalength ) then
    begin
      writeln('error sending data: '+virtualMIDIError(GetLastError()));
      exit;
    end;
  writeln( 'command: '+ bintostr( mididatabytes, datalength ) );
end;


begin
  writeln( 'teVirtualMIDI Delphi loopback sample' );
  writeln( 'using dll-version:    ' + virtualMIDIGetVersion( dummy, dummy, dummy, dummy ));
  writeln( 'using driver-version: ' + virtualMIDIGetDriverVersion( dummy, dummy, dummy, dummy ));

  virtualMIDILogging( TE_VM_LOGGING_MISC or TE_VM_LOGGING_RX or TE_VM_LOGGING_TX );

  port := virtualMIDICreatePortEx2( 'Delphi loopback', teVMCallback, nil, 65535, TE_VM_FLAGS_PARSE_RX );
  if port=nil then
    begin
      writeln('could not create port: '+virtualMIDIError(GetLastError()));
      exit;
    end;

  writeln( 'Virtual port created - press enter to close port again' );
  ReadKey();
  virtualMIDIClosePort( port );

  writeln( 'Virtual port closed - press enter to terminate application' );
  ReadKey();
end.
