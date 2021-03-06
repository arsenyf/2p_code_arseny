function populate_LAB_new_Rig_Person_Animal()
%% Should be inserted only in case this info isn't already in the database
%-----------------------------------
% 
% insert(LAB.ModifiedGene, {'CamK2a-tTA', 'When these Camk2a-tTA transgenic mice are mated to strain carrying a gene of interest under the regulatory control of a tetracycline-responsive promoter element (TRE; tetO), expression of the target gene can be blocked by administration of the tetracycline analog, doxycycline'} );
% insert(LAB.ModifiedGene, {'slc17a7 IRES Cre 1D12', 'Cre recombinase expression directed to Vglut1-expressing cells'} );
% insert(LAB.ModifiedGene, {'Ai94', 'TITL-GCaMP6s Cre/Tet-dependent, fluorescent calcium indicator GCaMP6s inserted into the Igs7 locus (TIGRE)'} );

% insert(LAB.Person, {'ars','ArsenyFinkelstein'} );
% insert(LAB.Rig, {'imaging1','2C.384','Two-photon imaging and photostimulation rig'} );


%% Should be inserted for each new animal
%-----------------------------------

subject_id=495876;
cage_num=191238;
dob='2021-08-04';
sex='M';
surgery_date='2021-10-18';

insert(LAB.Subject, {subject_id, 'ars',cage_num ,dob,sex,'Other'} );

insert(LAB.Surgery, {subject_id, 1, 'ars',[surgery_date ' 00:00:00'],[surgery_date ' 00:00:00'],'Cranial Window ALM Left'} );
% insert(LAB.Surgery, {subject_id, 1, 'ars',[surgery_date ' 00:00:00'],[surgery_date ' 00:00:00'],'Cranial D-Window for mesoscope, Left'} );
insert(LAB.SurgeryProcedure, {subject_id, 1, 1, 'Bregma',-1500,2000,0,'Cranial Window 2.5/2.5/3'} );
insert(LAB.SurgeryLocation, {subject_id, 1, 1, 'left','ALM'} );
% insert(LAB.SurgeryLocation, {subject_id, 1, 1, 'left','all'} ); %for mesoscope

insert(LAB.SubjectGeneModification, {subject_id, 'CamK2a-tTA','Unknown','Unknown'} );
insert(LAB.SubjectGeneModification, {subject_id, 'slc17a7 IRES Cre 1D12','Unknown','Unknown'} );
insert(LAB.SubjectGeneModification, {subject_id, 'Ai94','Unknown','Unknown'} );


%% Layer 5
% insert(LAB.SubjectGeneModification, {subject_id, 'CamK2a-tTA','Unknown','Unknown'} );
% insert(LAB.SubjectGeneModification, {subject_id, 'Rbp4-cre','Unknown','Unknown'} );
% insert(LAB.SubjectGeneModification, {subject_id, 'Ai94','Unknown','Unknown'} );

%% CA1
% insert(LAB.Surgery, {subject_id, 1, 'ars',[surgery_date ' 00:00:00'],[surgery_date ' 00:00:00'],'Cranial Window ALM Left'} );
% % insert(LAB.Surgery, {subject_id, 1, 'ars',[surgery_date ' 00:00:00'],[surgery_date ' 00:00:00'],'Cranial D-Window for mesoscope, Left'} );
% insert(LAB.SurgeryProcedure, {subject_id, 1, 1, 'Bregma',1800,-2000,0,'Neocortex aspiration, hippocampal cannula implant 3mm diameter, 1.7 mm length'} );
% insert(LAB.SurgeryLocation, {subject_id, 1, 1, 'right','hippocampus'} );
% % insert(LAB.SurgeryLocation, {subject_id, 1, 1, 'left','all'} ); %for mesoscope
% insert(LAB.SubjectGeneModification, {subject_id, 'GP5.17','Unknown','Unknown'} );


% populate(LAB.CompleteGenotype)
