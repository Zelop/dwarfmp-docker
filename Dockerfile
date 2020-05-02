FROM ubuntu:latest
MAINTAINER Zelop#3289 at Discord

#Installing dependencies
RUN apt-get update -y && apt-get install -y libsdl-image1.2 libsdl-ttf2.0-0 libgtk2.0-0 libglu1-mesa openssl wget unzip

#Download and extract DF 47.04
RUN wget -q -O dwarff.tar.bz2 https://www.bay12games.com/dwarves/df_47_04_linux.tar.bz2 && tar -xvf dwarff.tar.bz2 && rm dwarff.tar.bz2

#Download precompiled dfhack and extract
#Replace dfhack-with-config.zip with dfhack.zip if you don't want to use the config menu.
RUN wget -q -O dfhack.zip https://github.com/Zelop/dfhack/releases/download/v0.1/dfhack-with-config.zip && unzip -o dfhack.zip && rm dfhack.zip

#Remove libstdc++ from df libs so it'll use the system one
RUN mv /df_linux/libs/libstdc++.so.6 /df_linux/libs/libstdc++.so.6.backup

#Set up init files
RUN chmod +x /df_linux/dfhack
RUN echo "enable dfplex" > /df_linux/dfhack.init
RUN sed -i 's/BIRTH_CITIZEN:A_D:D_D:P:R\b/BIRTH_CITIZEN:A_D:D_D/' /df_linux/data/init/announcements.txt
RUN sed -i 's/MOOD_BUILDING_CLAIMED:A_D:D_D:P:R\b/MOOD_BUILDING_CLAIMED:A_D:D_D/' /df_linux/data/init/announcements.txt
RUN sed -i 's/ARTIFACT_BEGUN:A_D:D_D:P:R\b/ARTIFACT_BEGUN:A_D:D_D/' /df_linux/data/init/announcements.txt
RUN sed -i 's/SOUND:YES\b/SOUND:NO/g' /df_linux/data/init/init.txt
RUN sed -i 's/WINDOWEDY:25\b/WINDOWEDY:50/g' /df_linux/data/init/init.txt
RUN sed -i 's/INTRO:YES\b/INTRO:NO/g' /df_linux/data/init/init.txt
RUN sed -i 's/AUTOSAVE:NONE\b/AUTOSAVE:SEASONAL/g' /df_linux/data/init/d_init.txt
RUN sed -i 's/PRINT_MODE:2D\b/PRINT_MODE:TEXT/g' /df_linux/data/init/init.txt

WORKDIR /df_linux/
env TERM xterm

CMD ./dfhack
