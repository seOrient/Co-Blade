function writeOupFilePanel(SIM, BLADE, WEB, SECNODES, Panel, NormS, ShearS, Buckle, OUT)

date = datestr(now, 'mmmm dd, yyyy HH:MM AM');
 
fid = fopen([SIM.outputDir filesep SIM.case '_Panel.out'], 'w');

fprintf(fid,'=====  Panel Data Output File  =================================================\r\n');
fprintf(fid,'Generated on %s by Co-Blade v%s \r\n', date, SIM.version);
fprintf(fid,'This line is for user comments. \r\n');
fprintf(fid,'\r\n');
         
if OUT.TAB_DEL
    dlm = '\t';
    fmt_header1 = [ repmat( [ dlm, '%s' ], 1, 12 ), '\r\n' ];  
    fmt_header2 = [ repmat( [ dlm, '%s' ], 1, 4 ), '\r\n' ];
else
    dlm = '  ';
    fmt_header1 = [ repmat( [ dlm, '%5.5s' ], 1, 3 ), ...
                    repmat( [ dlm, '%8.8s' ], 1, 4 ), ...
                    repmat( [ dlm, '%12.12s' ], 1, 2 ), ...
                    repmat( [ dlm, '%10.10s' ], 1, 3 ), ...
                    '\r\n' ]; 
    fmt_header2 = [ repmat( [ dlm, '%8.8s' ], 1, 1 ), ...
                    repmat( [ dlm, '%12.12s' ], 1, 3 ), ...
                    '\r\n' ];
end

header1 = {'panel',      '(-)'; ...
           'nNodes',     '(-)'; ...
           'nLam',       '(-)'; ...
           'xc_St',      '(-)'; ...  
           'xc_End',     '(-)'; ... 
           'b',          '(m)'; ... 
           't',          '(m)'; ... 
           'E_eff',      '(Pa)'; ... 
           'G_eff',      '(Pa)'; ... 
           'nu_eff',     '(-)'; ... 
           'density',    '(kg/m^3)'; ... 
           'buckleCrit', '(-)'};
fmt_number1 = [ repmat( [ dlm, '%5.0f' ], 1, 3 ), ...
                repmat( [ dlm, '%8.4f' ], 1, 4 ), ...
                repmat( [ dlm, '%12.4e' ], 1, 2 ), ...
                repmat( [ dlm, '%10.4f' ], 1, 3 ), ...
                '\r\n' ];
            
header2 = {'s',       '(m)'; ...
           's_zz_ou', '(Pa)'; ...
           's_zz_in', '(Pa)'; ...  
           's_zs',    '(Pa)'};
fmt_number2 = [ repmat( [ dlm, '%8.4f' ], 1, 1 ), ...
                repmat( [ dlm, '%12.4e' ], 1, 3 ), ...
                '\r\n' ];
            
for i = 1:BLADE.NUM_SEC
     
    nPanelsTop = Panel(i).Top.nPanels;
    nPanelsBot = Panel(i).Bot.nPanels;
    
    fprintf(fid,'================================================================================\r\n');
    
    fprintf(fid,['sec        =' dlm '%-6.0f \r\n'], i);
    fprintf(fid,['zSec       =' dlm '%-6.4f' dlm '(m)\r\n'], BLADE.zSec(i));
    fprintf(fid,['nPanelsTop =' dlm '%-6.0f \r\n'], nPanelsTop);
    fprintf(fid,['nPanelsBot =' dlm '%-6.0f \r\n'], nPanelsBot);
    fprintf(fid,['nWebs      =' dlm '%-6.0f \r\n'], WEB.nWebs(i));
    
    fprintf(fid,'\r\n');
        %% print the top panel data
        fprintf(fid,'    Top:');
        fprintf(fid, fmt_header1, header1{:,1});
        fprintf(fid,'        ');
        fprintf(fid, fmt_header1, header1{:,2});
        for n = 1:nPanelsTop
            fprintf(fid,'        ');
            fprintf(fid, fmt_number1, n, ...
                                      numel(Panel(i).Top.s{n}), ...
                                      Panel(i).Top.nLam(n), ...
                                      SECNODES.embNdsTop{i}(n), ...
                                      SECNODES.embNdsTop{i}(n+1), ...
                                      Panel(i).Top.s{n}(end), ...
                                      Panel(i).Top.t(n), ...
                                      Panel(i).Top.E_eff(n), ...
                                      Panel(i).Top.G_eff(n), ...
                                      Panel(i).Top.nu_eff(n), ...
                                      Panel(i).Top.massByV(n), ...
                                      Buckle(i).Top(n));       
        end
       
        fprintf(fid,'\r\n');
          
        for n = 1:nPanelsTop
        	fprintf(fid,['          panel:' dlm '%-6.0f\r\n'], n);
            fprintf(fid,'        ');
            fprintf(fid, fmt_header2, header2{:,1});
            fprintf(fid,'        ');
            fprintf(fid, fmt_header2, header2{:,2});
            for m = 1:numel(Panel(i).Top.s{n})
                fprintf(fid,'        ');
                fprintf(fid, fmt_number2, Panel(i).Top.s{n}(m), ...
                                          NormS(i).Top.stress_zz{n}(m), ...
                                          NormS(i).Top.stress_zz{n}(end-m+1), ...
                                          ShearS(i).Top.stress_zs{n}(m)); 
            end      
            fprintf(fid,'\r\n');
        end
        
        %% print the bottom panel data
        fprintf(fid,' Bottom:');
        fprintf(fid, fmt_header1, header1{:,1});
        fprintf(fid,'        ');
        fprintf(fid, fmt_header1, header1{:,2});
        for n = 1:nPanelsBot
            fprintf(fid,'        ');
            fprintf(fid, fmt_number1, n, ...
                                      numel(Panel(i).Bot.s{n}), ...
                                      Panel(i).Bot.nLam(n), ...
                                      SECNODES.embNdsBot{i}(n), ...
                                      SECNODES.embNdsBot{i}(n+1), ...
                                      Panel(i).Bot.s{n}(end), ...
                                      Panel(i).Bot.t(n), ...
                                      Panel(i).Bot.E_eff(n), ...
                                      Panel(i).Bot.G_eff(n), ...
                                      Panel(i).Bot.nu_eff(n), ...
                                      Panel(i).Bot.massByV(n), ...
                                      Buckle(i).Bot(n));       
        end
       
        fprintf(fid,'\r\n');
          
        for n = 1:nPanelsBot
        	fprintf(fid,['          panel:' dlm '%-6.0f\r\n'], n);
            fprintf(fid,'        ');
            fprintf(fid, fmt_header2, header2{:,1});
            fprintf(fid,'        ');
            fprintf(fid, fmt_header2, header2{:,2});
            for m = 1:numel(Panel(i).Bot.s{n})
                fprintf(fid,'        ');
                fprintf(fid, fmt_number2, Panel(i).Bot.s{n}(m), ...
                                          NormS(i).Bot.stress_zz{n}(m), ...
                                          NormS(i).Bot.stress_zz{n}(end-m+1), ...
                                          ShearS(i).Bot.stress_zs{n}(m)); 
            end      
            fprintf(fid,'\r\n');
        end
        
        %% print the web panel data
        fprintf(fid,'    Web:');
        fprintf(fid, fmt_header1, header1{:,1});
        fprintf(fid,'        ');
        fprintf(fid, fmt_header1, header1{:,2});
        for n = 1:WEB.nWebs(i)
            fprintf(fid,'        ');
            fprintf(fid, fmt_number1, n, ...
                                      numel(Panel(i).Web.s{n}), ...
                                      Panel(i).Web.nLam(n), ...
                                      SECNODES.webLocs{i}(n), ...
                                      SECNODES.webLocs{i}(n), ...
                                      Panel(i).Web.s{n}(end), ...
                                      Panel(i).Web.t(n), ...
                                      Panel(i).Web.E_eff(n), ...
                                      Panel(i).Web.G_eff(n), ...
                                      Panel(i).Web.nu_eff(n), ...
                                      Panel(i).Web.massByV(n), ...
                                      Buckle(i).Web(n));       
        end
       
        fprintf(fid,'\r\n');
          
        for n = 1:WEB.nWebs(i)
        	fprintf(fid,['          panel:' dlm '%-6.0f\r\n'], n);
            fprintf(fid,'        ');
            fprintf(fid, fmt_header2, header2{:,1});
            fprintf(fid,'        ');
            fprintf(fid, fmt_header2, header2{:,2});
            for m = 1:numel(Panel(i).Web.s{n})
                fprintf(fid,'        ');
                fprintf(fid, fmt_number2, Panel(i).Web.s{n}(m), ...
                                          NormS(i).Web.stress_zz{n}(m), ...
                                          NormS(i).Web.stress_zz{n}(end-m+1), ...
                                          ShearS(i).Web.stress_zs{n}(m)); 
            end      
            fprintf(fid,'\r\n');
        end
end

fclose(fid);
         
end % function writeOupFilePanel

